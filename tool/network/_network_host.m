//
//  MKNetworkHost.m
//  MKNetworkKit
//
//  Created by Mugunth Kumar (@mugunthkumar) on 23/06/14.
//  Copyright (C) 2011-2020 by Steinlogic Consulting and Training Pte Ltd

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "_network_host.h"
#import "_network_host_cache.h"
#import "NSDate+RFC1123.h"
#import "NSMutableDictionary+MKNKAdditions.h"
#import "NSHTTPURLResponse+MKNKAdditions.h"

NSUInteger const kMKNKDefaultCacheDuration = 600; // 10 minutes
NSUInteger const kMKNKDefaultImageCacheDuration = 3600*24*7; // 7 days
NSString *const kMKCacheDefaultDirectoryName = @"com.mknetworkkit.mkcache";

@interface _NetworkHostRequest (/*Private Methods*/)

@property (readwrite) NSHTTPURLResponse *response;
@property (readwrite) NSData *responseData;
@property (readwrite) NSError *error;
@property (readwrite) MKNKRequestState state;
@property (readwrite) NSURLSessionTask *task;

- (void) setProgressValue:(CGFloat) updatedValue;

@end

@interface _NetworkHost (/*Private Methods*/) <NSURLSessionDelegate>

/**
 *  Default sessions behave similarly to other Foundation methods for downloading URLs. They use a persistent disk-based cache and store credentials in the user’s keychain.
 
    ps:Default sessions 和其他的网络请求类似（和NSURLConnection类似），本地可以缓存文件。
 */
@property (readonly) NSURLSession *defaultSession;
/**
 *  Ephemeral sessions do not store any data to disk; all caches, credential stores, and so on are kept in RAM and tied to the session. Thus, when your app invalidates the session, they are purged automatically.
 
    ps:Ephemeral sessions 不会存储数据，这样会节约内存，但是每次请求都会重新加在数据，所以适合数据量较少的请求（比如加载一段微博信息）。
 */
@property (readonly) NSURLSession *ephemeralSession;
/**
 *  Background sessions are similar to default sessions, except that a separate process handles all data transfers. Background sessions have some additional limitations, described in “Background Transfer Considerations.”
 
    ps:Background sessions 和 default sessions类似，着重是后台下载或是上传功能，这个也是NSURLSession强大的地方，在APP退到后台以后我们还可以继续下载或是上传，因为它由一个独立的进程在管理（原话：the actual transfer is performed by a separate process），当任务完成后它会激活APP进程，通知任务状态，然后你可以完成一些事情（比如保存下载的数据以便于用户下次进入APP使用）。
 */
@property (readonly) NSURLSession *backgroundSession;

@property _NetworkHostCache *dataCache;
@property _NetworkHostCache *responseCache;

@property dispatch_queue_t runningTasksSynchronizingQueue;
@property NSMutableArray *activeTasks;
@end

@implementation _NetworkHost

- (NSURLSession *)backgroundSession {
    static dispatch_once_t onceToken;
    static NSURLSessionConfiguration *backgroundSessionConfiguration;
    static NSURLSession *backgroundSession;
    dispatch_once(&onceToken, ^{
        backgroundSessionConfiguration =
        [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:
         [[NSBundle mainBundle] bundleIdentifier]];

        if([self.delegate respondsToSelector:@selector(networkHost:didCreateBackgroundSessionConfiguration:)]) {
            [self.delegate networkHost:self didCreateBackgroundSessionConfiguration:backgroundSessionConfiguration];
        }

        backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfiguration
                                                               delegate:self
                                                          delegateQueue:[[NSOperationQueue alloc] init]];
    });

    return backgroundSession;
}

- (NSURLSession *)defaultSession {
    static dispatch_once_t onceToken;
    static NSURLSessionConfiguration *defaultSessionConfiguration;
    static NSURLSession *defaultSession;
    dispatch_once(&onceToken, ^{
        defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

        if([self.delegate respondsToSelector:@selector(networkHost:didCreateDefaultSessionConfiguration:)]) {
            [self.delegate networkHost:self didCreateDefaultSessionConfiguration:defaultSessionConfiguration];
        }

        defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration
                                                       delegate:self
                                                  delegateQueue:[NSOperationQueue mainQueue]];
    });

    return defaultSession;
}

- (NSURLSession *)ephemeralSession {
    static dispatch_once_t onceToken;
    static NSURLSessionConfiguration *ephemeralSessionConfiguration;
    static NSURLSession *ephemeralSession;
    dispatch_once(&onceToken, ^{
        ephemeralSessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];

        if([self.delegate respondsToSelector:@selector(networkHost:didCreateEphemeralSessionConfiguration:)]) {
          [self.delegate networkHost:self didCreateEphemeralSessionConfiguration:ephemeralSessionConfiguration];
        }

        ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralSessionConfiguration
                                                       delegate:self
                                                  delegateQueue:[NSOperationQueue mainQueue]];
    });

    return ephemeralSession;
}

- (instancetype)init {
  if((self = [super init])) {
    
    self.runningTasksSynchronizingQueue = dispatch_queue_create("com.mknetworkkit.cachequeue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(self.runningTasksSynchronizingQueue, ^{
      self.activeTasks = [NSMutableArray array];
    });
  }
  
  return self;
}

- (instancetype) initWithHostName:(NSString*) hostName {
  
  _NetworkHost *engine = [[_NetworkHost alloc] init];
  engine.hostName = hostName;
  return engine;
}

-(void) enableCache {
  
  [self enableCacheWithDirectory:kMKCacheDefaultDirectoryName inMemoryCost:0];
}

-(void) enableCacheWithDirectory:(NSString*) cacheDirectoryPath inMemoryCost:(NSUInteger) inMemoryCost {
  
  self.dataCache = [[_NetworkHostCache alloc] initWithCacheDirectory:[NSString stringWithFormat:@"%@/data", cacheDirectoryPath]
                                              inMemoryCost:inMemoryCost];
  
  self.responseCache = [[_NetworkHostCache alloc] initWithCacheDirectory:[NSString stringWithFormat:@"%@/responses", cacheDirectoryPath]
                                                  inMemoryCost:inMemoryCost];
}

- (void)startUploadRequest:(_NetworkHostRequest *)request {
    if(!request || !request.request) {

        NSAssert((request && request.request),
             @"Request is nil, check your URL and other parameters you use to build your request");
        return;
    }

    /**
     * Warning:
         1、Background Transfer Considerations——Only upload and download tasks are supported (no data tasks).
         So, the uploadTaskWithRequest:request fromData:bodyData methods may not support.
         
         2、uploadTaskWithRequest:request fromFile:uploadURL progress:nil completionHandler
         the uploadURL should be—— Local file URLs (file:///)
     */
//    request.task = [self.backgroundSession uploadTaskWithRequest:request.request
//                                                      fromData:request.multipartFormData];
    request.task = [self.defaultSession uploadTaskWithRequest:request.request fromData:request.multipartFormData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Completion handler goes here, just leave -(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{} empty.

        request.responseData = data;
        request.response = (NSHTTPURLResponse *)response;
        request.error = error;
        if(error) {
            request.state = MKNKRequestStateError;
        } else {
            request.state = MKNKRequestStateCompleted;
        }
        
        dispatch_sync(self.runningTasksSynchronizingQueue, ^{
            [self.activeTasks removeObject:request];
        });
    }];
    
    dispatch_sync(self.runningTasksSynchronizingQueue, ^{
        [self.activeTasks addObject:request];
    });
    request.state = MKNKRequestStateStarted;
}

- (void)startDownloadRequest:(_NetworkHostRequest *)request {
  
  static dispatch_once_t onceToken;
  static BOOL methodImplemented = YES;
  dispatch_once(&onceToken, ^{
    methodImplemented = [[[UIApplication sharedApplication] delegate]
                         respondsToSelector:
                         @selector(application:handleEventsForBackgroundURLSession:completionHandler:)];
  });
  
  if(!methodImplemented) {
    
    NSLog(@"application:handleEventsForBackgroundURLSession:completionHandler: is not implemented in your application delegate. Download tasks might not work properly. Implement the method and set the completionHandler value to MKNetworkHost's backgroundSessionCompletionHandler");
  }
  
  if(!request || !request.request) {
    
    NSLog(@"Request is nil, check your URL and other parameters you use to build your request");
    return;
  }
  
//  request.task = [self.backgroundSession downloadTaskWithRequest:request.request];
    // modified by 7
    request.task = [self.defaultSession downloadTaskWithRequest:request.request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        request.responseData = nil;
        request.response = (NSHTTPURLResponse *)response;
        request.error = error;
        if(error) {
            request.state = MKNKRequestStateError;
        } else {
            request.state = MKNKRequestStateCompleted;
        }
        
        dispatch_sync(self.runningTasksSynchronizingQueue, ^{
            [self.activeTasks removeObject:request];
        });
    }];
    
  dispatch_sync(self.runningTasksSynchronizingQueue, ^{
    [self.activeTasks addObject:request];
  });
  request.state = MKNKRequestStateStarted;
}

- (void)startRequest:(_NetworkHostRequest *)request {
  NSLog(@"%@",request.request);
  if(!request || !request.request) {
    
    NSLog(@"Request is nil, check your URL and other parameters you use to build your request");
    return;
  }
  
  if(request.cacheable && !request.doNotCache) {
    
    NSHTTPURLResponse *cachedResponse = self.responseCache[@(request.hash)];
    NSDate *cacheExpiryDate = cachedResponse.cacheExpiryDate;
    NSTimeInterval expiryTimeFromNow = [cacheExpiryDate timeIntervalSinceNow];
    
    if(cachedResponse.isContentTypeImage && !cacheExpiryDate) {
      
      expiryTimeFromNow =
      cachedResponse.hasRequiredRevalidationHeaders ? kMKNKDefaultCacheDuration : kMKNKDefaultImageCacheDuration;
    }
    
    if(cachedResponse.hasDoNotCacheDirective || !cachedResponse.hasHTTPCacheHeaders) {
      
      expiryTimeFromNow = kMKNKDefaultCacheDuration;
    }
    
    NSData *cachedData = self.dataCache[@(request.hash)];
    
    if(cachedData) {
      request.responseData = cachedData;
      request.response = cachedResponse;
      
      if(expiryTimeFromNow > 0 && !request.alwaysLoad) {
        
        request.state = MKNKRequestStateResponseAvailableFromCache;
        return; // don't make another request
      } else {
        
        request.state = expiryTimeFromNow > 0 ? MKNKRequestStateResponseAvailableFromCache :
        MKNKRequestStateStaleResponseAvailableFromCache;
      }
    }
  }
  
  NSURLSession *sessionToUse = self.defaultSession;
  
  if(request.isSSL || request.requiresAuthentication) {
    
    sessionToUse = self.ephemeralSession;
  }
  
  NSURLSessionDataTask *task = [sessionToUse
                                dataTaskWithRequest:request.request
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                  
                                    NSLog(@"response = %@", response);
                                    
                                  if(request.state == MKNKRequestStateCancelled) {
                                    
                                    request.response = (NSHTTPURLResponse*) response;
                                    if(error) {
                                      request.error = error;
                                    }
                                    if(data) {
                                      request.responseData = data;
                                    }
                                    return;
                                  }
                                  if(!response) {
                                    
                                    request.response = (NSHTTPURLResponse*) response;
                                    request.error = error;
                                    request.responseData = data;
                                    request.state = MKNKRequestStateError;
                                    return;
                                  }
                                  
                                  request.response = (NSHTTPURLResponse*) response;
                                  
                                  if(request.response.statusCode >= 200 && request.response.statusCode < 300) {
                                    
                                    request.responseData = data;
                                    request.error = error;
                                  } else if(request.response.statusCode == 304) {
                                    
                                    // don't do anything
                                    
                                  } else if(request.response.statusCode >= 400) {
                                    request.responseData = data;
                                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                                    if(response) userInfo[@"response"] = response;
                                    if(error) userInfo[@"error"] = error;
                                    
                                    NSError *httpError = [NSError errorWithDomain:@"com.mknetworkkit.httperrordomain"
                                                                             code:request.response.statusCode
                                                                         userInfo:userInfo];
                                    request.error = httpError;
                                    
                                    // if subclass of host overrides errorForRequest: they can provide more insightful error objects by parsing the response body.
                                    // the super class implementation just returns the same error object set in previous line
                                    request.error = [self errorForCompletedRequest:request];
                                  }
                                  
                                  if(!request.error) {
                                    
                                    if(request.cacheable) {
                                      self.dataCache[@(request.hash)] = data;
                                      self.responseCache[@(request.hash)] = response;
                                    }
                                    
                                    dispatch_sync(self.runningTasksSynchronizingQueue, ^{
                                      [self.activeTasks removeObject:request];
                                    });
                                    
                                    request.state = MKNKRequestStateCompleted;
                                  } else {
                                    
                                    dispatch_sync(self.runningTasksSynchronizingQueue, ^{
                                      [self.activeTasks removeObject:request];
                                    });
                                    request.state = MKNKRequestStateError;
                                  }
                                }];
  
  request.task = task;
  
  dispatch_sync(self.runningTasksSynchronizingQueue, ^{
    [self.activeTasks addObject:request];
  });
  
  request.state = MKNKRequestStateStarted;
}

- (_NetworkHostRequest *)requestWithURLString:(NSString *)urlString {
    _NetworkHostRequest *request = [[_NetworkHostRequest alloc] initWithURLString:urlString
                                                                   params:nil
                                                                 bodyData:nil
                                                               httpMethod:@"GET"];
    [self prepareRequest:request];

    return request;
}

- (_NetworkHostRequest *)requestWithURLString:(NSString *)urlString params:(NSDictionary *)params httpMethod:(NSString *)httpMethod {
    _NetworkHostRequest *request = [[_NetworkHostRequest alloc] initWithURLString:urlString
                                                                           params:params
                                                                         bodyData:nil
                                                                       httpMethod:httpMethod];
    [self prepareRequest:request];
    
    return request;
}

- (_NetworkHostRequest *)requestWithPath:(NSString *)path {
  
  return [self requestWithPath:path params:nil httpMethod:@"GET" body:nil ssl:self.secureHost];
}

- (_NetworkHostRequest *)requestWithPath:(NSString *)path params:(NSDictionary *)params {
  
  return [self requestWithPath:path params:params httpMethod:@"GET" body:nil ssl:self.secureHost];
}

- (_NetworkHostRequest *)requestWithPath:(NSString *)path
                                  params:(NSDictionary *)params
                              httpMethod:(NSString *)httpMethod {
  
  return [self requestWithPath:path params:params httpMethod:httpMethod body:nil ssl:self.secureHost];
}

- (_NetworkHostRequest *)requestWithPath:(NSString *)path
                                  params:(NSDictionary *)params
                              httpMethod:(NSString *)httpMethod
                                    body:(NSData *)bodyData
                                     ssl:(BOOL)useSSL {
  
  if (self.hostName == nil) {
    
    NSLog(@"Hostname is nil, use requestWithURLString: method to create absolute URL operations");
    return nil;
  }
  
  NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@",
                                useSSL ? @"https" : @"http",
                                self.hostName];
  
  if(self.portNumber != 0)
    [urlString appendFormat:@":%lu", (unsigned long)self.portNumber];
  
  if(self.path)
    [urlString appendFormat:@"/%@", self.path];
  
  if(![path isEqualToString:@"/"]) { // fetch for root?
    
    if(path.length > 0 && [path characterAtIndex:0] == '/') // if user passes /, don't prefix a slash
      [urlString appendFormat:@"%@", path];
    else if (path != nil)
      [urlString appendFormat:@"/%@", path];
  }
  
  _NetworkHostRequest *request = [[_NetworkHostRequest alloc] initWithURLString:urlString
                                                                   params:params
                                                                 bodyData:bodyData
                                                               httpMethod:httpMethod.uppercaseString];
  
  request.parameterEncoding = self.defaultParameterEncoding;
  [request addHeaders:self.defaultHeaders];
  [self prepareRequest:request];
  return request;
}

// You can override this method to tweak request creation
// But ensure that you call super
- (void)prepareRequest:(_NetworkHostRequest *)request {
  
  if(!request.cacheable || request.ignoreCache) return;
  
  NSHTTPURLResponse *cachedResponse = self.responseCache[@(request.hash)];
  
  NSString *lastModified = [cachedResponse.allHeaderFields objectForCaseInsensitiveKey:@"Last-Modified"];
  NSString *eTag = [cachedResponse.allHeaderFields objectForCaseInsensitiveKey:@"ETag"];
  
  if(lastModified) [request addHeaders:@{@"IF-MODIFIED-SINCE" : lastModified}];
  if(eTag) [request addHeaders:@{@"IF-NONE-MATCH" : eTag}];
}

- (NSError *)errorForCompletedRequest:(_NetworkHostRequest *)completedRequest {
  
    // to be overridden by subclasses to tweak error objects by parsing the response body
    return completedRequest.error;
}

#pragma mark -
#pragma mark NSURLSession Authentication delegates

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
  
  if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
    
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
  }
  
  __block _NetworkHostRequest *matchingRequest = nil;
  [self.activeTasks enumerateObjectsUsingBlock:^(_NetworkHostRequest *request, NSUInteger idx, BOOL *stop) {
    
    if([request.task isEqual:task]) {
      matchingRequest = request;
      *stop = YES;
    }
  }];
  
  if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] ||
     [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]){
    
    if([challenge previousFailureCount] == 3) {
      completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    } else {
      NSURLCredential *credential = [NSURLCredential credentialWithUser:matchingRequest.username
                                                               password:matchingRequest.password
                                                            persistence:NSURLCredentialPersistenceNone];
      if(credential) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
      } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
      }
    }
  }
}

#pragma mark -
#pragma mark NSURLSession (Download/Upload) Progress notification delegates

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
  
    // empty
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
  
  float progress = (float)(((float)totalBytesSent) / ((float)totalBytesExpectedToSend));
  [self.activeTasks enumerateObjectsUsingBlock:^(_NetworkHostRequest *request, NSUInteger idx, BOOL *stop) {
    
    if([request.task isEqual:task]) {
      [request setProgressValue:progress];
      *stop = YES;
    }
  }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
  
  [self.activeTasks enumerateObjectsUsingBlock:^(_NetworkHostRequest *request, NSUInteger idx, BOOL *stop) {
    
    if([request.task.currentRequest.URL.absoluteString isEqualToString:downloadTask.currentRequest.URL.absoluteString]) {
      
      NSError *error = nil;
      if(![[NSFileManager defaultManager] moveItemAtPath:location.path toPath:request.downloadPath error:&error]) {
        
        NSLog(@"Failed to save downloaded file at requested path [%@] with error %@", request.downloadPath, error);
      }
      
      *stop = YES;
    }
  }];
  
  // call completion handler if the app was resumed and got connected again to our background session
  [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
    NSUInteger count = dataTasks.count + uploadTasks.count + downloadTasks.count;
    
    if (count == 0) {
      
      void (^backgroundSessionCompletionHandlerCopy)() = self.backgroundSessionCompletionHandler;
      
      if (self.backgroundSessionCompletionHandler) {
        self.backgroundSessionCompletionHandler = nil;
        backgroundSessionCompletionHandlerCopy();
      }
    }
  }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  
  float progress = (float)(((float)totalBytesWritten) / ((float)totalBytesExpectedToWrite));
  [self.activeTasks enumerateObjectsUsingBlock:^(_NetworkHostRequest *request, NSUInteger idx, BOOL *stop) {
    
    if([request.task.currentRequest.URL.absoluteString isEqualToString:downloadTask.currentRequest.URL.absoluteString]) {
      [request setProgressValue:progress];
    }
  }];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
  
  if(session == self.backgroundSession) {
    
    NSLog(@"Session became invalid with error: %@", error);
  }
}

@end
