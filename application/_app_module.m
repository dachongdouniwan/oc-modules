//
//  _app_module.m
//  kata
//
//  Created by fallen on 17/3/10.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_app_module.h"
#import "_building_component.h"

@implementation _AppModule

@def_singleton(_AppModule)

- (void)initServices {
    
}

- (void)initComponents {
    
    // Gao de
    {
        TODO("这个key初始化，应该放在service")
        [ComponentMap sharedInstance].config.apiKey = @"604cd55b5aa21c47b2907b65ca555d57";
        
        [[ComponentMap sharedInstance] initGDAPIKey];
        
//        [suite.service.location powerOn];
        TODO("这里会崩溃，还不知道为啥，后续解决。")
    }
    
    // Init pay module
    {
        
    }
    
}

@end
