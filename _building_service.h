//
//  _building_component.h
//  student
//
//  Created by fallen on 17/4/21.
//  Copyright © 2017年 alliance. All rights reserved.
//

// 核心服务
#import "APNService.h"
#import "LocationService.h"
#import "PayService.h"
#import "AliPayService.h"
#import "WalletPayService.h"
#import "UnionPayService.h"
#import "WechatPayService.h"
#import "TimeService.h"
#import "AssetsService.h"

// 核心业务组件
// Component 可复用业务组件、常规业务组件，两者可以使用共同抽象，组建内分层，请参考具体代码
#import "ComponentMap.h"
#import "ComponentShare.h"

// web
#import "_web_service.h"

