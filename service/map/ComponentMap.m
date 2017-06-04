//
//  ComponentMap.m
//  component
//
//  Created by fallen.ink on 3/16/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "ComponentMap.h"
#import "ComponentMapConfig.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#define SdkKey_GaoDe_Customer          @"604cd55b5aa21c47b2907b65ca555d57"

#define SdkKey_GaoDe_Html5         @"6ac773a2a022262da557dcd4d4793c2c" // js api
#define SdkKey_Gaode_Web           @"c86d5a251d4eb5af15244cc06946234e" // web api

/* 使用高德API，请注册Key，注册地址：http://lbs.amap.com/console/key
 */

const static NSString *GDMapAPIKey = SdkKey_GaoDe_Customer;

const static NSString *GDMapH5APIKey = SdkKey_GaoDe_Html5; //高德JavascriptAPI
const static NSString *GDMapWebAPIKey = SdkKey_Gaode_Web; //高德WebAPI

@implementation ComponentMap

@def_singleton( ComponentMap )

@def_prop_instance(ComponentMapConfig, config)

+ (void)load {

//    exceptioning(@"请配置api key")
//    [AppConfig adapterAppHairDresser:^{
//        [self sharedInstance].config.apiKey = SdkKey_GaoDe_HairDresser;
//    } appCustomer:^{
//        [self sharedInstance].config.apiKey = SdkKey_GaoDe_Customer;
//    } appMaster:^{
//        [self sharedInstance].config.apiKey = SdkKey_GaoDe_Customer;
//    }];
}

- (void)initGDAPIKey { // 高德 MapKit configure.
    if ([GDMapAPIKey length] == 0)
    {
#define kMALogTitle @"提示"
#define kMALogContent @"apiKey为空，请检查key是否正确设置"
        
        NSLog(@"%@", [NSString stringWithFormat:@"[MAMapKit] %@", kMALogContent]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMALogTitle message:kMALogContent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        });
    } else {
        self.config.apiKey = GDMapAPIKey;
    }
    
    [MAMapServices sharedServices].apiKey = self.config.apiKey;
    [AMapSearchServices sharedServices].apiKey = self.config.apiKey;
    [AMapLocationServices sharedServices].apiKey = self.config.apiKey;
    
    LOG(@"GaoDe map version: %@", [[MAMapServices sharedServices] SDKVersion]);
}

@end
