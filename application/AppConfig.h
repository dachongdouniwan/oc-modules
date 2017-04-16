//
//  AppConfiguration.h
//  component
//
//  Created by fallen.ink on 3/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  多端bundleid的枚举
 */
#define BundleIdentifier_HairDresser @"com.yzsee.mfs"
#define BundleIdentifier_Customer    @"com.yzsee.gk"
#define BundleIdentifier_Master      @"com.yzsee.ds"

@interface AppConfig : NSObject

@singleton( AppConfig )

@property (nonatomic, readonly, strong) NSString *platformName;
@property (nonatomic, readonly, strong) NSString *appName; // app display name , as it display at front screen~
@property (nonatomic, readonly, strong) NSString *appIdentifier;
@property (nonatomic, readonly, assign) int32_t appVersionSerial; // 用于版本比对的整形数字, 存放在info.plist中，key is :CFApplicationVersionSerial

/**
 *  公用代码中，判断是哪个端
 */
@property (nonatomic, readonly) BOOL isHairDesserApp;
@property (nonatomic, readonly) BOOL isCustomerApp;
@property (nonatomic, readonly) BOOL isMasterApp;

#pragma mark - 家长版、老师端、助教端用的比较少的差异点用这种方法实现

+ (void)adapterAppHairDresser:(Block)blockOnHairDresser
                  appCustomer:(Block)blockOnCustomer;

+ (void)adapterAppHairDresser:(Block)handlerOnHairDresser
                  appCustomer:(Block)handlerOnCustomer
                    appMaster:(Block)handlerOnMaster;

// 后台请求统一添加appplatform, appname, appversion三个字段，方便线上问题紧急修复（带URL域名）
// 后台请求统一添加guid（唯一标示符），方便后台分析日志（带URL域名）
+ (NSMutableString *)appendCommonArgsFromURLString:(NSString *)str;

@end

#define app_platform_name   [AppConfig sharedInstance].platformName
#define app_name            [AppConfig sharedInstance].appName
#define app_identifier      [AppConfig sharedInstance].appIdentifier
#define app_version_serial  [AppConfig sharedInstance].appVersionSerial
#define app_udid            [[_System sharedInstance] deviceUDID]
