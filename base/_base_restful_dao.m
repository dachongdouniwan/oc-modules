//
//  _base_restful_dao.m
//  kata
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_greats.h"
#import "_base_restful_dao.h"

@implementation _BaseRestfulDao

#ifdef USE_NETWORK_LIGHT_KIT

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
            failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            NSError *error = [self checkResponseIfHaveError:response];
            if (error) { // service error
                failureHandler(error);
            } else {
                successHandler([self filteredResponse:response]);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)GET:(NSString *)path param:(NSDictionary *)param success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [self showHud];
    
    // 是否有统一添加的参数
    NSMutableDictionary *mutableParameters = [param mutableCopy];
    NSDictionary *appendingParameters = [self appendParametersOnApi:path];
    
    if (appendingParameters) {
        [mutableParameters addEntriesFromDictionary:appendingParameters];
    }
    
    _NetworkHostRequest *request = [self.host requestWithPath:path params:mutableParameters httpMethod:@"GET"];
    NSDictionary *addingHeader = [self constructHeaderWith:request api:path];
    if (addingHeader) [request addHeaders:addingHeader];
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        // 隐藏指示器
        [self dismissHud];
        
        if (completedRequest.error) { // http error
            failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            NSError *error = [self checkResponseIfHaveError:response];
            if (error) { // service error
                failureHandler(error);
            } else {
                successHandler([self filteredResponse:response]);
            }
        }
    }];
    
    [self.host startRequest:request];
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers successHandler:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler {
    // 显示指示器
    [self showHud];
    
    // 是否有统一添加的参数
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    NSDictionary *appendingParameters = [self appendParametersOnApi:url];
    
    if (appendingParameters) {
        [mutableParameters addEntriesFromDictionary:appendingParameters];
    }
    
    _NetworkHostRequest *request = [self.host requestWithPath:url params:mutableParameters httpMethod:@"POST"];
    if (headers.allKeys.count) {
        [request addHeaders:headers];
    }
    
    NSDictionary *addingHeader = [self constructHeaderWith:request api:url];
    if (addingHeader) [request addHeaders:addingHeader];
    
    [request addCompletionHandler:^(_NetworkHostRequest *completedRequest) {
        
        // 隐藏指示器
        [self dismissHud];
        
        if (completedRequest.error) { // http error
            failureHandler(completedRequest.error);
        } else {
            NSDictionary *response = completedRequest.responseAsJSON;
            NSError *error = [self checkResponseIfHaveError:response];
            if (error) { // service error
                failureHandler(error);
            } else {
                successHandler([self filteredResponse:response]);
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

#else

#endif

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
