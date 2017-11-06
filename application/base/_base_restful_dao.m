//
//  _base_restful_dao.m
//  kata
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_greats.h"
#import "_base_restful_dao.h"
#import "_xml.h"
#import "MainViewManager.h"

@implementation _BaseRestfulDao

@def_prop_instance(_NetworkHost, host)

- (instancetype)init {
    if (self = [super init]) {
        self.host.defaultHeaders = [self defaultHeader];
        self.host.hostName = [self hostname];
        self.host.defaultParameterEncoding = MKNKParameterEncodingJSON;
    }
    
    return self;
}

- (void)GET:(NSString *)url success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [self showHud];
    
    _NetworkHostRequest *request = [self.host requestWithURLString:url];
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [self dismissHud];
        
        if (completedRequest.error) { // http error
            if (failureHandler) failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            
            LOG(@"response = %@", response);
            
            NSError *error = [self checkResponseIfHaveError:response];
            if (error) { // service error
                if (failureHandler) failureHandler(error);
            } else {
                if (successHandler) successHandler([self filteredResponse:response]);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)GETFORXML:(NSString *)url success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [self showHud];
    
    _NetworkHostRequest *request = [self.host requestWithURLString:url];
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [self dismissHud];
        
        if (completedRequest.error) { // http error
            if (failureHandler) failureHandler(completedRequest.error);
        } else {
            NSString *response = completedRequest.responseAsString;
            
            LOG(@"response = %@", response);
            
            if (successHandler) successHandler([response XMLDictionary]);
        }
    }];
    
    [self.host startRequest:request];
}

- (void)GET:(NSString *)path param:(NSDictionary *)param success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    LOG(@"host = %@, api = %@, parameter = %@", self.hostname, path, param);
    
    // 显示指示器
    [self showHud];
    
    // 是否有统一添加的参数
    NSMutableDictionary *mutableParameters = [@{} mutableCopy];
    NSDictionary *appendingParameters = [self appendParametersOnApi:path];
    
    if (appendingParameters) {
        [mutableParameters addEntriesFromDictionary:appendingParameters];
    }
    
    if (param) {
        [mutableParameters addEntriesFromDictionary:param];
    }
    
    _NetworkHostRequest *request = [self.host requestWithPath:path params:mutableParameters httpMethod:@"GET"];
    NSDictionary *addingHeader = [self constructHeaderWith:request api:path];
    if (addingHeader) [request addHeaders:addingHeader];
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [self dismissHud];
        
        if (completedRequest.error) { // http error
            if (failureHandler) failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            
            LOG(@"response = %@", response);
            
            NSError *error = [self checkResponseIfHaveError:response];
            if (error) { // service error
                if (failureHandler) failureHandler(error);
            } else {
                if (successHandler) successHandler([self filteredResponse:response]);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)param headers:(NSDictionary *)headers successHandler:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    
    // 显示指示器
    [self showHud];
    
    // 是否有统一添加的参数
    
    NSMutableDictionary *mutableParameters = [@{} mutableCopy];
    NSDictionary *appendingParameters = [self appendParametersOnApi:path];
    
    if (appendingParameters) { // 统一追加
        [mutableParameters addEntriesFromDictionary:appendingParameters];
    }
    
    if (param) { // 当前接口参数
        [mutableParameters addEntriesFromDictionary:param];
    }
    
    LOG(@"host = %@, api = %@, parameter = %@", self.hostname, path, mutableParameters);
    
    _NetworkHostRequest *request = [self.host requestWithPath:path params:mutableParameters httpMethod:@"POST"];
    if (headers.allKeys.count) {
        [request addHeaders:headers];
    }
    
    NSDictionary *addingHeader = [self constructHeaderWith:request api:path];
    if (addingHeader) [request addHeaders:addingHeader];
    
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [self dismissHud];
        
        if (completedRequest.error) { // http error
            
            LOG(@"api = %@, error = %@", path, completedRequest.error);
            
            if (failureHandler) failureHandler(completedRequest.error);
        } else {
            NSString *responseString = [completedRequest responseAsString];
            
//            TODO("ugly")
            // map nullable to blank
            {
                if ([responseString contains:@"\"(null)\""]) {
                    responseString = [responseString replaceAll:@"\"(null)\"" with:@"\"\""];
                }
                if ([responseString contains:@"(null)"]) { // 这应该是部分替换
                    responseString = [responseString replaceAll:@"(null)" with:@""];
                }
                if ([responseString contains:@"\"null\""]) {
                    responseString = [responseString replaceAll:@"\"null\"" with:@"\"\""];
                }
                if ([responseString contains:@"null"]) {
                    responseString = [responseString replaceAll:@"null" with:@"\"\""];
                }
            }
            
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //NSDictionary *response = [responseString];//completedRequest.responseAsJSON;

            // load-teacher-homepage loadTeacherInfoSuccess
            LOG(@"response = %@", response);
            if ([[response objectForKey:@"errorCode"] isEqualToString:@"USER_1011"]) {
                [app_inst.context.uninitialize logout];
#ifdef datapayload
                [datapayload clear];
#endif
                [[MainViewManager sharedInstance] loadLoginView];
            }
            
            NSError *error = [self checkResponseIfHaveError:response];
            if (error) { // service error
                if (failureHandler) failureHandler(error);
            } else {
                if (successHandler) successHandler([self filteredResponse:response]);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)UPLOAD:(NSString *)url
       headers:(NSDictionary *)headers
  constructing:(NetLightConstructingBodyBlock)constructingHandler
       success:(ObjectBlock)successHandler
      progress:(PercentBlock)progressHandler
       failure:(ErrorBlock)failureHandler {
    _NetworkHostRequest *request = [self.host requestWithURLString:url params:nil httpMethod:@"POST"];
    [request addHeaders:headers];
    
    // Construct uploading data
    NSAssert(constructingHandler, @"Please implement constructingHandler");
    
    constructingHandler(request);
    
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        
        if (completedRequest.error) { // http error
            if (failureHandler) failureHandler(completedRequest.error);
        } else if (completedRequest.response.statusCode != 200) {
            
            LOG(@"Error response = %@", completedRequest.response);
            
            if (failureHandler) failureHandler(nil);
            
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            
            LOG(@"response = %@", response);
            
//            NSError *error = [self checkResponseIfHaveError:response];
//            if (error) { // service error
//                if (failureHandler) failureHandler(error);
//            } else {
//                if (successHandler) successHandler(response);
//            }
            
            NSNumber *errorCode = response[@"errorCode"];
            NSString *errorMessage = response[@"errorMessage"];
            
            
            UNUSED(errorMessage)
            
            if (errorCode.integerValue == 0) {
                if (successHandler) successHandler(response);
                
            } else {
                if (failureHandler) failureHandler(nil);
            }
        }
    }];
    [request addUploadProgressChangedHandler:^(_NetworkHostRequest *completedRequest) {
        if (progressHandler) {
            progressHandler(completedRequest.progress);
        }
    }];
    
    [self.host startUploadRequest:request];
}

- (void)DOWNLOAD:(NSString *)url {
    //    MKNetworkOperation *op = [self operationWithURLString:remoteURL];
    //    [op setFreezable:YES];
    //    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:filePath
    //                                                            append:YES]];
    //
    //    [self enqueueOperation:op];
    //    return op;
}

#pragma mark - _BaseDaoRequestConstructProtocol

- (NSDictionary *)defaultHeader {
//    NSMutableDictionary *defaultHeader = [@{} mutableCopy];
//    NSString *token = LOGINTOKEN; // tk
//    NSString *sessionId = LOGINSESSIONID; // si
//    
//    // content type
//    [defaultHeader addEntriesFromDictionary:@{@"Accept":@"application/json", @"Content-Type":@"application/json;charset=utf-8"}];
//    
//    if (token.length) {
//        [defaultHeader setObject:token forKey:@"tk"];
//    }
//    
//    if (sessionId.length) {
//        [defaultHeader setObject:sessionId forKey:@"si"];
//    }
    
    return @{@"Accept":@"application/json", @"Content-Type":@"application/json;charset=utf-8"};
}

- (NSDictionary *)constructHeaderWith:(id)request api:(NSString *)api {
    return nil;
}

- (NSDictionary *)appendParametersOnApi:(NSString *)api {
    return nil;
}

- (NSString *)hostname {
    return @"";
}

- (NSError *)checkResponseIfHaveError:(NSDictionary *)response {
    NSDictionary *baseResponse = response[@"baseResponse"];
    NSNumber *errorCode = baseResponse[@"error_code"];
    NSString *errorMessage = baseResponse[@"error_message"];
    
    if (errorCode.integerValue == 0) {
        return nil;
    } else {
        return [NSError errorWithDomain:classnameof_Class(self.class) code:errorCode.integerValue userInfo:@{@"error_message":errorMessage}];
    }
}

- (NSDictionary *)filteredResponse:(NSDictionary *)originResponse {
    return originResponse;
}

#pragma mark - _BaseDaoHuddingProtocol

- (void)showHud {
    
}

- (void)dismissHud {
    
}

#pragma mark -
#pragma mark - Database

//- (void)createTable:(NSString *)sql {
//    FMDatabase *db = [[Database sharedInstance] openDatabase];
//    if (![db executeUpdate:sql]) {
//        NSLog(@"Create table failed");
//    }
//    [db close];
//}
//
//- (void)clearDatabase {
//    
//}
//
//- (void)clearCache {
//    
//}

@end
