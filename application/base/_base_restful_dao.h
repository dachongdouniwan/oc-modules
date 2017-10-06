//
//  _base_restful_dao.h
//  kata
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_tool_network_light.h"
#import "_base_protocol.h"

// ----------------------------------
// Class code
// ----------------------------------

@interface _BaseRestfulDao : NSObject <_BaseDaoRequestConstructProtocol, _BaseDaoHuddingProtocol>

@prop_instance(_NetworkHost, host)

/**
 *
 */
- (void)GET:(NSString *)url success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

/**
 *
 */
- (void)GETFORXML:(NSString *)url success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

/**
 *
 */
- (void)GET:(NSString *)path param:(NSDictionary *)param success:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

/**
 *
 */
- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers successHandler:(ObjectBlock)successHandler failure:(ErrorBlock)failureHandler;

/**
 *
 */
typedef void (^ NetLightConstructingBodyBlock)(_NetworkHostRequest *request); // //    [request attachData:nil forKey:nil mimeType:nil suggestedFileName:nil]

- (void)UPLOAD:(NSString *)url
       headers:(NSDictionary *)headers
  constructing:(NetLightConstructingBodyBlock)constructingHandler
       success:(ObjectBlock)successHandler
      progress:(PercentBlock)progressHandler
       failure:(ErrorBlock)failureHandler;

/**
 *
 */
- (void)DOWNLOAD:(NSString *)url; //还没完成

@end

