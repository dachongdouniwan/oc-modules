//
//  _app_config.h
//  student
//
//  Created by fallen.ink on 13/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_building_precompile.h"
#import "_app_rater.h"

@protocol APNServiceDelegate;

@interface _AppConfig : NSObject

@singleton( _AppConfig )

// 广告配置
@prop_assign(BOOL, enabledLaunchAdvertise) // 启动广告，默认：NO
@prop_assign(CGFloat, launchAdvertiseDuration)

// 地图-高德SDK配置，没有配置，默认关闭
@prop_strong(NSString *, mapApiKey)

// 分享-微信配置
@prop_strong(NSString *, wechatAppId)
@prop_strong(NSString *, wechatScheme)

// 评分配置
@prop_singleton(_AppRater, rater)

// 推送配置
@prop_strong(NSString *, pushKey)
@prop_strong(NSString *, pushChannel) // 需要监听的频道
@prop_strong(id<APNServiceDelegate>, pushDelegate)

@end

#define config_inst [_AppConfig sharedInstance]
