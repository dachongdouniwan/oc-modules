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

- (void)willLaunch;

- (void)didLaunch;

- (void)willTerminate;

- (void)didBecomeActive;

- (void)willEnterForeground;

- (void)willEnterBackground;

- (void)willResignActive;

@end

@protocol ApplicationRuntimePeriodProtocol <NSObject>

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
