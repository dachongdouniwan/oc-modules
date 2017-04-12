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
// Protocol code
// ----------------------------------

@protocol ApplicationLifeStyleProtocol <NSObject> // 应用生命周期

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

@end

@protocol ApplicationRuntimePeriodProtocol <NSObject> // 非必要的业务流程回调

- (void)onLaunch;

- (void)onAdvertise;

@end

// ----------------------------------
// Class code
//
// 参考的SamuraiApp
// ----------------------------------

@interface _Application : UIResponder <UIApplicationDelegate, ApplicationLifeStyleProtocol, ApplicationRuntimePeriodProtocol>

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

@end
