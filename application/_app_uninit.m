//
//  _app_uninit.m
//  kata
//
//  Created by fallen on 17/3/10.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_app_uninit.h"
#import "_app_context.h"

@implementation _AppUninit

@def_singleton( _AppUninit )

- (void)logout {
    [context_inst.user clear];
    
    if (is_method_implemented(self.delegate, logout)) {
        [self.delegate logout];
    }
}

@end
