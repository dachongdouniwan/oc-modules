//
//  _application.h
//  kata
//
//  Created by fallen.ink on 22/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_precompile.h"
#import "_greats.h"

// ----------------------------------
// Cluster code
// ----------------------------------

#import "_app_context.h"

#import "_app_module.h"
#import "_app_rule.h"
#import "_app_appearance.h"
#import "_app_config.h"

// ----------------------------------
// Protocol code
// ----------------------------------

@protocol ApplicationLifeStyleProtocol <NSObject> // 应用生命周期，不要这里做UI的事情，业务UI请关注ApplicationRuntimePeriodProtocol

- (void)willLaunch; // 程序即将加载

- (void)didLaunch; // 程序加载完毕

- (void)willTerminate; // 程序即将终止

- (void)didBecomeActive; // 程序获取焦点

- (void)willEnterForeground; // 程序即将从后台，回到前台

- (void)willEnterBackground; // 程序即将从前台，退到后台

- (void)willResignActive; // 程序即将失去焦点

@end

@protocol ApplicationNofiticationProtocol <NSObject> // 应用推送回调（外部不关心api版本问题）



@end

@protocol ApplicationExternalEventProtocol <NSObject> // 应用外部事件回调

- (void)whenSignificantTimeChange; // 当系统时间发生改变时

- (void)whenMemoryOverflow; // 内存要溢出了

@end

@protocol ApplicationRuntimePeriodProtocol <NSObject> // 非必要的业务流程回调

- (void)onConfig:(_AppConfig *)appConfig;

- (void)onLaunch;

/**
 * @param adSettingHandler 需要通过网络请求等，设置新的广告数据，当前只需要提供image信息，跳转信息自行处理
 *
 * @return Block 需要返回点击事件处理句柄，注意：该句柄会在onLaunch后面调用
 */
- (Block)onAdvertise:(StringBlock)adSettingHandler;

@end

// ----------------------------------
// Class code
//
// 参考的SamuraiApp
// ----------------------------------

@interface _Application : UIResponder <
    UIApplicationDelegate,
    ApplicationLifeStyleProtocol,
    ApplicationRuntimePeriodProtocol,
    ApplicationExternalEventProtocol
>

@notification( PushEnabled )
@notification( PushError )

@notification( LocalNotification )
@notification( RemoteNotification )

@notification( EnterBackground );
@notification( EnterForeground );
@notification( Ready )

@prop_strong( UIWindow *,			window );
@prop_strong( NSString *,			pushToken );
@prop_strong( NSError *,			pushError );
@prop_strong( NSString *,			sourceUrl );
@prop_strong( NSString *,			sourceBundleId );

@prop_readonly( BOOL,				active );
@prop_readonly( BOOL,				inactive );
@prop_readonly( BOOL,				background );

@prop_singleton( _AppConfig,        config );

@end
