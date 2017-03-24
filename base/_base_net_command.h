//
//  _base_request.h
//  student
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 alliance. All rights reserved.
//

#import "_network.h"
#import "_base_model.h"

// ----------------------------------
// Request class code
// ----------------------------------

@interface _BaseRequest : _Model <_NetModelProtocol>

@end

@interface _BaseUploadRequest : _Model  <_NetModelProtocol>

@property (nonatomic, strong) NSString *filename;

@property (nonatomic, assign) NSUInteger fileLength;

@end


// ----------------------------------
// Response class code
// ----------------------------------

#pragma mark - 类型定义

enum : NSUInteger {
    NetworkError_ok = 1,
    NetworkError_fail = 0,
};

typedef enum : NSUInteger {
    /**
     *  业务错误
     */
    ErrorLevel_Business = 1,
    /**
     *  数据库错误
     */
    ErrorLevel_DB = 2,
    /**
     *  运行时错误
     */
    ErrorLevel_Runtime = 3,
} ErrorLevelType;

#pragma mark -

@interface _BaseResponse : _Model

@property (nonatomic, assign) int32_t result;
@property (nonatomic, assign) ErrorLevelType errorLevel;
@property (nonatomic, assign) int32_t errorCode;
@property (nonatomic, strong) NSString *errorMessage;

@end

// ----------------------------------
// Easycoding class code
// ----------------------------------

@interface NSObject ( NetCommand )

/**
 *  启动请求
 *
 *  @param model          实现了<_NetModelProtocol>的model
 *  @param successHandler 返回反序列化之后的对象：_NetModel的子类
 *  @param failureHandler 错误处理
 *
 *  @return 请求
 */
- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                     success:(ObjectBlock)successHandler
                     failure:(ErrorBlock)failureHandler;

/**
 *  启动请求，携带参数
 *
 *  @param model          实现了<_NetModelProtocol>的model
 *  @param parameters     参数
 *  @param successHandler 返回反序列化之后的对象
 *  @param failureHandler 错误处理
 *
 *  @return 请求
 */
- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                  parameters:(NSDictionary *)parameters
                     success:(ObjectBlock)successHandler
                     failure:(ErrorBlock)failureHandler;

/**
 *  启动请求，携带参数，构造HTTP data
 *
 *  @param model            实现了<_NetModelProtocol>的model
 *  @param parameters       参数
 *  @param constructHandler 构造数据
 *  @param successHandler   返回反序列化之后的对象
 *  @param failureHandler   错误处理
 *
 *  @return 请求
 */
- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                  parameters:(NSDictionary *)parameters
            constructingData:(NetConstructingBodyBlock)constructHandler
                     success:(ObjectBlock)successHandler
                     failure:(ErrorBlock)failureHandler;

/**
 *  启动请求，携带参数，构造HTTP data，错误时是否重连
 
 *  先做选择性重连
 */
- (_NetRequest *)requestWith:(_Model<_NetModelProtocol> *)model
                     success:(ObjectBlock)successHandler
   failureWithReconnectOrNot:(NetRequestFailureWithReconnectOrNotBlock)failureHandler;

@end
