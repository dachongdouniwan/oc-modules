//
//  _service.h
//  component
//
//  Created by fallen.ink on 4/12/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

/**
 *  @knowledge
 
 *  服务
 */

#import "_module.h"

@interface _Service : _Module

/**
 *  @brief 是否可用，1. 依赖系统服务，而用户没有打开 2. 依赖外部服务，而用户没有安装
 */
- (BOOL)available;

/**
 *  @brief 运行时，用户可以热开关
 */
- (void)powerOn;
- (void)powerOff;

@end

@namespace( service )
