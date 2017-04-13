//
//  _app_config.m
//  student
//
//  Created by fallen.ink on 13/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_app_config.h"

@implementation _AppConfig

@def_singleton( _AppConfig )

- (instancetype)init {
    if (self = [super init]) {
        self.enabledLaunchAdvertise = NO;
        self.launchAdvertiseDuration = 3.f;
    }
    
    return self;
}

@end
