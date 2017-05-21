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

- (void)logout;

@end

@protocol AppUninitDelegate <NSObject>



@end
