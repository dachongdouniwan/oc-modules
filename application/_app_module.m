//
//  _app_module.m
//  kata
//
//  Created by fallen on 17/3/10.
//  Copyright © 2017年 fallenink. All rights reserved.
//

#import "_app_module.h"
#import "_app_config.h"
#import "_building_component.h"

@implementation _AppModule

@def_singleton(_AppModule)

- (void)initServices {
    
}

- (void)initComponents {
    
    // Gao de
    {
        [ComponentMap sharedInstance].config.apiKey = config_inst.mapApiKey;
        
        [[ComponentMap sharedInstance] initGDAPIKey];
        
        [suite.service.location powerOn];
    }
    
    //share
    {
        [[SNShareService sharedInstance] wechatConfig:^BOOL(SNShareService_Config *config) {
            config.appId = config_inst.wechatAppId;
            config.scheme = config_inst.wechatScheme;
            
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
