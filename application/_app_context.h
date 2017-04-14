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

@interface _AppContext : NSObject

@prop_singleton( _AppInit, initialize )
@prop_singleton( _AppUninit, uninitialize )

@end

/**
 * AppContext可以有多个
 */
