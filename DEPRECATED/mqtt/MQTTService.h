//
//  ComponentMqtt.h
//  component
//
//  Created by qingqing on 16/1/12.
//  Copyright © 2016年 OpenTeam. All rights reserved.
//
//  关于mqtt的必要的api调用

#import "foundation/_foundation.h"
#import "service/_service.h"

@interface MQTTService : _Service

@singleton( MQTTService )

@property (nonatomic, strong, readonly) id mqttConnectionInfo;

// 获取mqtt的配置信息
- (RACSignal*)mqttConfigForLoginUserSignal;

- (void)getMQTTConfigForRegisterUser;

@end
