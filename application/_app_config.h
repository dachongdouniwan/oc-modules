//
//  _app_config.h
//  student
//
//  Created by fallen.ink on 13/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_building_precompile.h"

@interface _AppConfig : NSObject

@singleton( _AppConfig )

@property (nonatomic, assign) BOOL enabledLaunchAdvertise; // 启动广告，默认：NO

@property (nonatomic, assign) CGFloat launchAdvertiseDuration;

@end
