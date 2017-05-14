//
//  _application.m
//  kata
//
//  Created by fallen.ink on 22/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_application.h"
#import "XHLaunchAd.h"
#import "_pragma_push.h"

@implementation _Application

@def_notification( PushEnabled )
@def_notification( PushError )

@def_notification( LocalNotification )
@def_notification( RemoteNotification )

@def_notification( EnterBackground );
@def_notification( EnterForeground );

@def_notification( Ready )

@def_prop_strong( UIWindow *,			window );
@def_prop_strong( NSString *,			pushToken );
@def_prop_strong( NSError *,			pushError );
@def_prop_strong( NSString *,			sourceUrl );
@def_prop_strong( NSString *,			sourceBundleId );

@def_prop_dynamic( BOOL,				active );
@def_prop_dynamic( BOOL,				inactive );
@def_prop_dynamic( BOOL,				background );

@def_prop_singleton( _AppConfig,        config );

#pragma mark - 生命周期

// 说明：当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
- (void)applicationWillResignActive:(UIApplication *)application {
    [self willResignActive];
}

// 说明：当应用程序入活动状态执行，这个刚好跟上面那个方法相反
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self didBecomeActive];
}

// 说明：当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self willEnterBackground];
}

// 说明：当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self willEnterForeground];
}

// 说明：当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。
- (void)applicationWillTerminate:(UIApplication *)application {
    [self willTerminate];
    
    [self onCleanup];
}

// 说明：当程序载入后执行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self onConfig:self.config];
    
    [self didLaunch];
    
    if (is_method_overrided(self.class, _Application.class, @selector(onSynchronize))) {
        [self onSynchronize];
        
        XCT_BLOCK; // TODO:这是只做测试，不是最终方案
    }
    
    /**
     * 广告页面
     */
    if (self.config.enabledLaunchAdvertise) {
        /**
         *  1.显示启动页广告
         */
        @weakify(self)
        __block BOOL  advertiseClicked = NO;
        __block Block onAdvertiseClickHandler = nil;
        [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
            
            onAdvertiseClickHandler = [self onAdvertise:^(NSString *imgUrl) { // 等应用层回调，传入新的广告信息
                [launchAd setImageUrl:imgUrl
                             duration:self.config.launchAdvertiseDuration
                             skipType:LaunchAdSkipTypeTimeText
                              options:XHWebImageDefault
                            completed:^(UIImage *image, NSURL *url) { // 广告加载完成事件
                    
                              } click:^{ // 点击事件
                                  advertiseClicked = YES;
                                  
                                  TODO("这里应该是立即触发的")
                              }];
            }];
        } showFinish:^{ //
            @strongify(self)
            
            [self onLaunch];
            
            //广告点击事件
            if (advertiseClicked) {
                if (onAdvertiseClickHandler) onAdvertiseClickHandler();
            }
        }];
    } else {
        /**
         * 业务UI的开始
         */
        [self onLaunch];
    }
    
    return YES;
}

#pragma mark - 推送

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

#pragma mark - 其他事件

// 说明：当系统时间发生改变时执行
- (void)applicationSignificantTimeChange:(UIApplication *)application {
    
}

// 说明：当StatusBar框将要变化时执行
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    
}

// 当StatusBar框变化完成后执行
- (void)application:(UIApplication *)application didChangeSetStatusBarFrame:(CGRect)oldStatusBarFrame {
    
}

// 说明：当StatusBar框方向将要变化时执行
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    
}

// 说明：当StatusBar框方向变化完成后执行
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    
}

// 说明：当通过url执行
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url { // iOS 2-9
    return [self application:application openURL:url sourceApplication:nil annotation:nonullify(nil)];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation { // iOS 2-9
    return [self onOpenUrl:url options:@{@"source":nonullify(sourceApplication),@"annotation":nonullify(annotation)}];
}
#endif

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options { // iOS 9-
    
    return [self onOpenUrl:url options:options];
}

// 说明：iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
    
}

#pragma mark - 空壳
#pragma mark - ApplicationLifeStyleProtocol
- (void)willLaunch {}
- (void)didLaunch {}
- (void)willTerminate {}
- (void)didBecomeActive {}
- (void)willEnterForeground {}
- (void)willEnterBackground {}
- (void)willResignActive {}

#pragma mark - ApplicationNofiticationProtocol

#pragma mark - ApplicationExternalEventProtocol
- (void)whenSignificantTimeChange {}
- (void)whenMemoryOverflow {}

#pragma mark - ApplicationRuntimePeriodProtocol
- (void)onConfig:(_AppConfig *)appConfig {}
- (UIViewController *)forLaunchViewController { return nil; };
- (void)onSynchronize { if (is_method_overrided(self.class, _Application.class, @selector(onSynchronize))) XCT_GOON };
- (void)onLaunch {}
- (Block)onAdvertise:(StringBlock)adSettingHandler {return nil;}
- (void)onCleanup {}
- (BOOL)onOpenUrl:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {return YES;}

@end

#import "_pragma_pop.h"
