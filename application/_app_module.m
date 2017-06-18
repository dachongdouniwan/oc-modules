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
        
        [suite.service.location powerOn];
    }
    
    //share
    {
        [[SNShareService sharedInstance] wechatConfig:^BOOL(SNShareService_Config *config) {
            config.appId = @"wx8a167c0d7f84fdd9";
            config.scheme = @"wx8a167c0d7f84fdd9";
            
            config.supported = YES;
            
            return YES;
        } qqConfig:^BOOL(SNShareService_Config *config) {            
            return NO;
        } sinaConfig:^BOOL(SNShareService_Config *config) {
            return NO;
        } smsConfig:^BOOL(SNShareService_Config *config) {
            return NO;
        } emailConfig:^BOOL(SNShareService_Config *config) {
            return NO;
        } linkConfig:^BOOL(SNShareService_Config *config) {
            return NO;
        }];
    }
    
    // Init pay module
    {
        
    }
    
}

@end
