//
//  _base_protocol.h
//  student
//
//  Created by fallen on 17/3/15.
//  Copyright © 2017年 alliance. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------
// Protocol code
// ----------------------------------

@protocol _BaseDaoRequestConstructProtocol <NSObject>

/**
 *  默认头
 
 *  token
 *  sesstionId
 
 *  @{@"Accept":@"application/json", @"Content-Type":@"application/json;charset=utf-8"
 */
- (NSDictionary *)defaultHeader;

/**
 *  统一处理的headers
 */
- (NSDictionary *)constructHeaderWith:(id)request api:(NSString *)api;

/**
 *  like : @"139.196.189.53:8080/web"
 */
- (NSString *)hostname;

/**
 *  识别业务错误
 */
- (NSError *)checkResponseIfHaveError:(NSDictionary *)response;

/**
 *  过滤reponse
 */
- (NSDictionary *)filteredResponse:(NSDictionary *)originResponse;

@end

@protocol _BaseDaoHuddingProtocol <NSObject>

/**
 * hud显示最好有"次数计数"，免得重复叠加
 */

- (void)showHud;

- (void)dismissHud;

@end
