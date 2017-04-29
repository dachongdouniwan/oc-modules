//
//  NSObject+Easy.h
//  component
//
//  Created by fallen.ink on 4/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_precompile.h"
#import "UIView+.h"
#import "UITableViewCell+.h"
#import "UICollectionViewCell+.h"
#import "UIViewController+.h"

@interface NSObject (Easy)

#pragma mark Success / Error / Progress

- (void)showSuccess:(NSString *)message;
- (void)showError:(NSString *)message;
- (void)showInfo:(NSString *)message;

- (void)showProgress;
- (void)showProgressTitle:(NSString *)title;
- (void)increaseProgress:(CGFloat)progress;

#pragma mark - Hud - heads up display

- (void)dismissHUD;
- (void)showActivityHUD;

// C 端使用
- (void)showLoadingHUD;
- (void)showLoadingHUDWithMaskColor:(UIColor *)color topSpacesRatio:(CGFloat)ratio;
- (void)dismissLoadingHUD;

#pragma mark - Toast

- (void)showToastWithText:(NSString *)text;
- (void)showToastWithText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI;

#pragma mark - AlertView

- (void)showAlertView:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)name cancelHandler:(Block)cancelHandler;
+ (void)showAlertView:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)name;
- (void)showAlertView:(NSString*)title message:(NSString*)message :(NSString*)enterStr DEPRECATED;

#pragma mark - Initializer

- (void)initDefault;
- (void)initObserver;
- (void)uinitObserver;

#pragma mark - No data view

- (void)showBlankView; // 空页面的填充视图
- (void)dismissBlankView;

#pragma mark - TableView setup fresh
- (void)setupRefreshWithTarget:(id)target head:(SEL)headerRefreshingHandler foot:(SEL)footerRefreshingHandler;

@end
