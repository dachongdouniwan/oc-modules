//
//  _app_config.h
//  student
//
//  Created by fallen.ink on 13/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_building_precompile.h"
#import "_app_rater.h"

@interface _AppConfig : NSObject

@singleton( _AppConfig )

// 广告配置
@prop_assign(BOOL, enabledLaunchAdvertise) // 启动广告，默认：NO
@prop_assign(CGFloat, launchAdvertiseDuration)

// 地图-高德SDK配置
@prop_strong(NSString *, mapApiKey)

// 分享-微信配置
@prop_strong(NSString *, wechatAppId)
@prop_strong(NSString *, wechatScheme)

// 评分配置
@prop_singleton(_AppRater, rater)

@end

#define config_inst [_AppConfig sharedInstance]
