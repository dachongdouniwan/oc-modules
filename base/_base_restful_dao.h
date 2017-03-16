//
//  _base_restful_dao.h
//  kata
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_tool_network_light.h"
#import "_base_protocol.h"

#define USE_NETWORK_LIGHT_KIT

// ----------------------------------
// Class code
// ----------------------------------

@interface _BaseRestfulDao : NSObject <_BaseDaoRequestConstructProtocol, _BaseDaoHuddingProtocol>

@prop_instance(_NetworkHost, host)

#pragma mark - Data access object

#ifdef USE_NETWORK_LIGHT_KIT

- (void)GET:(NSString *)url success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

- (void)GET:(NSString *)path param:(NSDictionary *)param success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers successHandler:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

- (void)UPLOAD:(NSString *)url; // 还没完成

- (void)DOWNLOAD:(NSString *)url; //还没完成

#else

#endif

@end

