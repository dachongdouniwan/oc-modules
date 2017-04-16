//
//  AppVersioner.h
//  consumer
//
//  Created by fallen.ink on 18/10/2016.
//
//

#import <Foundation/Foundation.h>

@interface AppVersioner : NSObject

@property (nonatomic, weak) UIWindow *window; // to show exit animation, as AppDelegate.window.

@property (nonatomic, strong) NSString *appLookupUrl;
@property (nonatomic, strong) NSString *appId; // need to config

- (void)checkUpdate;

@end
