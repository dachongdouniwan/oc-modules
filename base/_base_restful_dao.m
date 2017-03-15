//
//  _base_restful_dao.m
//  kata
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_greats.h"
#import "_base_restful_dao.h"

#ifdef USE_NETWORK_LIGHT_KIT

@implementation _base_restful_dao

#ifdef USE_NETWORK_LIGHT_KIT

- (instancetype)init {
    if (self = [super init]) {
        NSMutableDictionary *defaultHeader = [@{} mutableCopy];
        NSString *token = LOGINTOKEN; // tk
        NSString *sessionId = LOGINSESSIONID; // si
        
        // content type
        [defaultHeader addEntriesFromDictionary:@{@"Accept":@"application/json", @"Content-Type":@"application/json;charset=utf-8"}];
        
        if (token.length) {
            [defaultHeader setObject:token forKey:@"tk"];
        }
        
        if (sessionId.length) {
            [defaultHeader setObject:sessionId forKey:@"si"];
        }
        
        self.host.defaultHeaders = defaultHeader;
        self.host.hostName = api_main_service;
        self.host.defaultParameterEncoding = MKNKParameterEncodingJSON;
    }
    
    return self;
}

- (void)GET:(NSString *)url success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [SVProgressHUD show];
    
    _NetworkHostRequest *request = [self.host requestWithURLString:url];
    //    [request addHeaders:];
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        if (completedRequest.error) { // http error
            failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            NSError *error = [self.class checkResponseIfHaveError:response];
            if (error) { // service error
                failureHandler(error);
            } else {
                successHandler(response);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)GET:(NSString *)path param:(NSDictionary *)param success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [SVProgressHUD show];
    
    _NetworkHostRequest *request = [self.host requestWithPath:path params:param httpMethod:@"GET"];
    
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        if (completedRequest.error) { // http error
            failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            NSError *error = [self.class checkResponseIfHaveError:response];
            if (error) { // service error
                failureHandler(error);
            } else {
                successHandler(response);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers successHandler:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [SVProgressHUD show];
    
    _NetworkHostRequest *request = [self.host requestWithPath:url params:parameters httpMethod:@"POST"];
    if (headers.allKeys.count) {
        [request addHeaders:headers];
    }
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
        if (completedRequest.error) { // http error
            failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            NSError *error = [self.class checkResponseIfHaveError:response];
            if (error) { // service error
                failureHandler(error);
            } else {
                successHandler(response);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)UPLOAD:(NSString *)url {
    //    MKNetworkOperation *op = [self operationWithPath:urlString
    //                                              params:body
    //                                          httpMethod:@"POST"];
    //
    //    [op addFile:file forKey:@"media"];
    //
    //    // setFreezable uploads your images after connection is restored!
    //    [op setFreezable:YES];
    //
    //    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
    //
    //        NSString *value = [completedOperation responseString];
    //
    //        completionBlock(value);
    //    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
    //
    //        errorBlock(error);
    //    }];
    //
    //    [self enqueueOperation:op];
    //
    //    return op;
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

+ (NSError *)checkResponseIfHaveError:(NSDictionary *)response {
    NSDictionary *baseResponse = response[@"baseResponse"];
    NSNumber *errorCode = baseResponse[@"error_code"];
    NSString *errorMessage = baseResponse[@"error_message"];
    
    if (errorCode.integerValue == 0) {
        return nil;
    } else {
        return [NSError errorWithDomain:classnameof_Class(self) code:errorCode.integerValue userInfo:@{@"error_message":errorMessage}];
    }
}

#else

#endif

#pragma mark -
#pragma mark - Database

#pragma mark -
#pragma mark - DB

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

#else

#endif
