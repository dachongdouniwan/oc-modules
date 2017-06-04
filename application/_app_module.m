//
//  _app_module.m
//  kata
//
//  Created by fallen on 17/3/10.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_app_module.h"
#import "ComponentMap.h"

@implementation _AppModule

@def_singleton(_AppModule)

- (void)initMap {
    
    // Gao de
    {
        [[ComponentMap sharedInstance] initGDAPIKey];
    }
    
    // Init pay module
    
}

@end
