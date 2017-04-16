//
//  AppConfiguration.m
//  component
//
//  Created by fallen.ink on 3/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

@def_singleton( AppConfig )

#pragma mark - Initialize

- (instancetype)init {
    if (self = [super init]) {
        [self initCommon];
    }
    
    return self;
}

- (void)initCommon {
    _isCustomerApp = NO;
    _isHairDesserApp = NO;
    _isMasterApp = NO;

    _platformName       = @"ios";
    _appName            = app_display_name;
    
    NSString *bundleId = app_bundle_id;
    NSArray *bundleStrs = [bundleId componentsSeparatedByString:@"."];
    _appIdentifier = [bundleStrs safeStringAtIndex:2];
    
    NSString *appVersionSerialString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFApplicationVersionSerial"];
    _appVersionSerial = [appVersionSerialString intValue];
    
    NSAssert(appVersionSerialString, @"请设置版本号");
    
    [self.class adapterAppHairDresser:^{
        _isHairDesserApp   = YES;
    } appCustomer:^{
        _isCustomerApp  = YES;
    } appMaster:^{
        _isMasterApp    = YES;
    }];
}



#pragma mark - Tools

+ (void)adapterAppHairDresser:(Block)blockOnHairDresser
                  appCustomer:(Block)blockOnCustomer {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if ([bundleID hasPrefix:BundleIdentifier_HairDresser]) {
        if (blockOnHairDresser) {
            blockOnHairDresser();
        }
    } else if ([bundleID hasPrefix:BundleIdentifier_Customer]) {
        if (blockOnCustomer) {
            blockOnCustomer();
        }
    } else {
#ifdef DEBUG
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出大事了"
                                                            message:@"配置类初始化失败了！！！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"赶紧去看看"
                                                  otherButtonTitles:nil];
        [alertView show];
#endif
    }
}

+ (void)adapterAppHairDresser:(Block)handlerOnHairDresser
                  appCustomer:(Block)handlerOnCustomer
                    appMaster:(Block)handlerOnMaster {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if ([bundleID hasPrefix:BundleIdentifier_HairDresser]) {
        if (handlerOnHairDresser) {
            handlerOnHairDresser();
        }
    } else if ([bundleID hasPrefix:BundleIdentifier_Customer]) {
        if (handlerOnCustomer) {
            handlerOnCustomer();
        }
    } else if ([bundleID hasPrefix:BundleIdentifier_Master]) {
        if (handlerOnMaster) {
            handlerOnMaster();
        }
    } else {
#ifdef DEBUG
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出大事了"
                                                            message:@"配置类初始化失败了！！！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"赶紧去看看"
                                                  otherButtonTitles:nil];
        [alertView show];
#endif
    }
}

#pragma mark -

// 后台请求统一添加appplatform, appname, appversion三个字段，方便线上问题紧急修复（带URL域名）
// 后台请求统一添加guid（唯一标示符），方便后台分析日志（带URL域名）
+ (NSMutableString *)appendCommonArgsFromURLString:(NSString *)str {
    static NSString *const apppltFirstSubStr = @"?appplatform=";
    static NSString *const appnameFirstSubStr = @"?appname=";
    static NSString *const appverFirstSubStr = @"?appversion=";
    static NSString *const guidFirstSubStr = @"?guid=";
    
    static NSString *const apppltNotFirstSubStr = @"&appplatform=";
    static NSString *const appnameNotFirstSubStr = @"&appname=";
    static NSString *const appverNotFirstSubStr = @"&appversion=";
    static NSString *const guidNotFirstSubStr = @"&guid=";
    
    NSMutableString *resultString = [NSMutableString stringWithString:str];
    if (([resultString rangeOfString:apppltFirstSubStr].location == NSNotFound) && ([resultString rangeOfString:apppltNotFirstSubStr].location == NSNotFound)) {
        [resultString appendFormat:@"%@%@", ([resultString rangeOfString:@"?"].location == NSNotFound) ? apppltFirstSubStr : apppltNotFirstSubStr, app_platform_name];
    }
    if (([resultString rangeOfString:appnameFirstSubStr].location == NSNotFound) && ([resultString rangeOfString:appnameNotFirstSubStr].location == NSNotFound)) {
        [resultString appendFormat:@"%@%@", appnameNotFirstSubStr, app_name];
    }
    if (([resultString rangeOfString:appverFirstSubStr].location == NSNotFound) && ([resultString rangeOfString:appverNotFirstSubStr].location == NSNotFound)) {
        [resultString appendFormat:@"%@%@", appverNotFirstSubStr, app_bundle_name];
    }
    if (([resultString rangeOfString:guidFirstSubStr].location == NSNotFound) && ([resultString rangeOfString:guidNotFirstSubStr].location == NSNotFound)) {
        [resultString appendFormat:@"%@%@", guidNotFirstSubStr, app_udid];
    }
    
    return resultString;
}

@end
