//
//  _base_request.m
//  student
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 alliance. All rights reserved.
//

#import "_base_net_command.h"
#import "_pragma_push.h"
#import "_ui_core.h"

// ----------------------------------
// Request source code
// ----------------------------------

@implementation _BaseRequest

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return @{@"Content-Type":@"application/json; charset=utf8"};
}

@end

@implementation _BaseUploadRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return @{@"Content-Type" : @"image/jpeg",
             @"name" : self.filename,
             @"Content-Length" : [NSString stringWithFormat:@"%tu", self.fileLength]};
}

- (NetRequestMethod)requestMethod {
    return NetRequestMethod_Post;
}

- (NSString *)responseClassname {
    return nil;
}

- (RequestSerializerType)requestSerializerType {
    return RequestSerializerType_HTTP;
}

@end

// ----------------------------------
// Response source code
// ----------------------------------

@implementation _BaseResponse

@end

// ----------------------------------
// Easycoding source code
// ----------------------------------

@implementation NSObject ( NetCommand )

// 利用 NetModel的hash对应于request???

#pragma mark - Public

- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                     success:(ObjectBlock)successHandler
                     failure:(ErrorBlock)failureHandler {
    return [self requestWith:model
                  parameters:@{}
                     success:successHandler
                     failure:failureHandler];
}

- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                  parameters:(NSDictionary *)parameters
                     success:(ObjectBlock)successHandler
                     failure:(ErrorBlock)failureHandler {
    return [self requestWith:model
                  parameters:parameters
            constructingData:nil
                     success:successHandler
                     failure:failureHandler];
}

- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                  parameters:(NSDictionary *)parameters
            constructingData:(NetConstructingBodyBlock)constructHandler
                     success:(ObjectBlock)successHandler
                     failure:(ErrorBlock)failureHandler {
    // Check if is request model
    if (is_protocol_implemented(self, _NetModelProtocol)) {
        exceptioning(@"Your NetModel is executing request method, should implement protocol(NetRequestProtocol)");
    }
    
    // create request by _NetRequestProtocol
    _NetRequest *request = [_NetRequest new];
    
    request.requestData  = model;
    request.HTTPHeader = parameters;
    request.constructingBodyBlock = constructHandler;
    request.successHandler = successHandler;
    request.failureHandler = failureHandler;
    
    if (request.failureHandler == nil) {
        // Use default failure handling, alert with error message.
        
        @weakify(self)
                request.failureHandler = ^(NSError *error){
                    @strongify(self)
        
                    [self dismissHUD];
        
                    [self dismissLoadingHUD];
        
                    [self showError:error.message];
                };
    }
    
    // Enqueue request
    [[_Network sharedInstance].client addRequest:request];
    
    [self onWillDealloc:^{
        [request cancel];
    }];
    
    return request;
}

#pragma mark - New apis

- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                     success:(ObjectBlock)successHandler
   failureWithReconnectOrNot:(NetRequestFailureWithReconnectOrNotBlock)failureHandler {
    // Check if is request model
    if (is_protocol_implemented(self, _NetModelProtocol)) {
        exceptioning(@"Your NetModel is executing request method, should implement protocol(NetRequestProtocol)");
    }
    
    // create request by _NetRequestProtocol
    _NetRequest *request = [_NetRequest new];
    
    request.requestData  = model;
    //    request.HTTPHeader = parameters;
    //    request.constructingBodyBlock = constructHandler;
    request.successHandler = successHandler;
    request.failureWithReconnectOrNotHandler = failureHandler;
    
    // Enqueue request
    [[_Network sharedInstance].client addRequest:request];
    
    [self onWillDealloc:^{
        [request cancel];
    }];
    
    return request;
}

@end

#import "_pragma_pop.h"
