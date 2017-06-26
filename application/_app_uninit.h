//
//  _app_uninit.h
//  kata
//
//  Created by fallen on 17/3/10.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_building_precompile.h"

@protocol AppUninitDelegate;

@interface _AppUninit : NSObject

@singleton( _AppUninit )

@prop_weak(id<AppUninitDelegate>, delegate)

- (void)logout;

@end

// 用户退出应用代理，DataCenter实现该代理，可以不需要直接依赖Logout View Action
@protocol AppUninitDelegate <NSObject>

- (void)logout;

@end
