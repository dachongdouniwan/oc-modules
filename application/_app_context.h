//
//  _app_context.h
//  kata
//
//  Created by fallen on 17/3/10.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "_app_init.h"
#import "_app_uninit.h"
#import "_app_user.h"

/**
 *  TODO: 当前还不支持多context, 但context和user是一对一的
 */

@interface _AppContext : NSObject

@singleton( _AppContext )

@prop_singleton( _AppInit, initialize )
@prop_singleton( _AppUninit, uninitialize )

@prop_singleton( _AppUser, user )

/**
    服务功能
 
    1. 地址、城市信息
 **/
// 位置信息

@prop_assign( double, longitude ) // 经度
@prop_assign( double, latitude) // 纬度
// 市信息
@prop_assign( int64_t, cityId )
@prop_assign( int64_t, cityCode )
@prop_strong( NSString *, cityCodes )
@prop_strong( NSString *, cityName )
// 省信息
@prop_assign( int64_t, provinceId )
@prop_assign( int64_t, provinceCode )
@prop_strong( NSString *, provinceName )
// 区信息
@prop_assign( int64_t, areaId )
@prop_assign( int64_t, areaCode )
@prop_strong( NSString *, areaName )

@end

#undef  context_inst
#define context_inst [_AppContext sharedInstance]
