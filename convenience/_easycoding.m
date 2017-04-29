//
//  NSObject+Easy.m
//  component
//
//  Created by fallen.ink on 4/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <objc/runtime.h>
#import "_foundation.h"
#import "_easycoding.h"

#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "LSYLoadingHUD.h"
#import "AlertView.h"
#import "UIView+Extension.h"

#import "_pragma_push.h"

/**
 *  1. HUD 透明显示层
 
    https://github.com/SVProgressHUD/SVProgressHUD/tree/master/SVProgressHUD
 
 *  2.
 */


@interface NSObject ()

@property (nonatomic, strong) NSString *progressTitle;

// Used for toast
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation NSObject (Easy)

// A category +load method is called after the class’s own +load method.
+ (void)load {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setMinimumDismissTimeInterval:1.f];                  // default is 5.0 seconds
    [SVProgressHUD setFadeInAnimationDuration:0.15];                    // default is 0.15 seconds
    [SVProgressHUD setFadeOutAnimationDuration:0.15];                   // default is 0.15 seconds
}

#pragma mark Success / Error / Progress

- (void)showSuccess:(NSString *)message {
    [SVProgressHUD showSuccessWithStatus:message];
}

- (void)showError:(NSString *)message {
    [SVProgressHUD showErrorWithStatus:message];
}

- (void)showInfo:(NSString *)message {
    [SVProgressHUD showInfoWithStatus:message];
}

- (void)showProgress {
    self.progressTitle = nil;
    [SVProgressHUD showProgress:0 status:nil];
}

- (void)showProgressTitle:(NSString *)title {
    self.progressTitle = title;
    [SVProgressHUD showProgress:0 status:title];
}

- (void)increaseProgress:(CGFloat)progress {
    [SVProgressHUD showProgress:progress status:self.progressTitle];
}

#pragma mark - Hud

- (void)dismissHUD {
    [SVProgressHUD dismiss];
}

- (void)showActivityHUD {
    [SVProgressHUD show];
}

#pragma mark - C client using hud

- (void)showLoadingHUD {
    if (class_equal(self, UIViewController.class)) {
        [self showCustomHUDWithText:nil maskColor:nil topSpacesRatio:0];
    }
    
}

- (void)showLoadingHUDWithMaskColor:(UIColor *)color topSpacesRatio:(CGFloat)ratio {
    if (class_equal(self, UIViewController.class)) {
        [self showCustomHUDWithText:nil maskColor:color topSpacesRatio:ratio];
    }
}

- (void)dismissLoadingHUD {
    if (class_equal(self, UIViewController.class)) {
        [self dismissCustomLoadingHUD];
    }
}

#pragma mark - Toast

- (void)showToastWithText:(NSString *)text {
    [self showToastWithText:text withImageName:nil blockUI:YES];
}

- (void)showToastWithText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 方案一：使用MBProgressHUD
        [self.progressHUD hideAnimated:NO];
        
        if ([[UIApplication sharedApplication] keyWindow]) {
            self.progressHUD = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
            
            // Full screen show.
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.progressHUD];
            [self.progressHUD bringToFront];
            
            self.progressHUD.label.text = text;
            if (([imageName length] > 0) && [UIImage imageNamed:imageName]) {
                self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                self.progressHUD.mode = MBProgressHUDModeCustomView;
            } else {
                self.progressHUD.mode = text.length > 0 ? MBProgressHUDModeText : MBProgressHUDModeIndeterminate;
                self.progressHUD.square = !(text.length > 0);
            }
            
            self.progressHUD.removeFromSuperViewOnHide = YES;
            self.progressHUD.userInteractionEnabled = needBlockUI;
            
            [self.progressHUD showAnimated:YES];
            
            [self.progressHUD hideAnimated:YES afterDelay:1.5];
        }
    });
}

#pragma mark -

- (void)showAlertView:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)name cancelHandler:(Block)cancelHandler {
    // 先隐藏 hud
    [self dismissHUD];
    [self dismissLoadingHUD];
    
    AlertView *alertView = [[AlertView alloc] initWithTitle:title message:message cancelButtonTitle:nil];
    [alertView addButtonWithTitle:name style:AlertActionStyleCancel handler:^(AlertView *alertView, AlertButtonItem *buttonItem) {
        if (cancelHandler) {
            cancelHandler();
        }
        
        [alertView dismiss];
    }];
    [alertView show];
}

+ (void)showAlertView:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)name {
    AlertView *alertView = [[AlertView alloc] initWithTitle:title message:message cancelButtonTitle:name];
    [alertView show];
    
    // If name nil, or empty, auto dismiss
    if (is_string_empty(name)) {
        [alertView performSelector:@selector(dismiss) withObjects:@[@(0), @(YES)] afterDelay:0.6f];
    }
}


- (void)showAlertView:(NSString *)title message:(NSString *)message :(NSString *)enterStr {
    [self.class showAlertView:title message:message cancelButtonName:enterStr];
}

#pragma mark - Initializer

- (void)initDefault {
    
}

- (void)initObserver {
    
}

- (void)uinitObserver {
    
}

#pragma mark - LSYLoadingHUD

- (void)showCustomHUDWithText:(NSString *)text maskColor:(UIColor *)color topSpacesRatio:(CGFloat)ratio {
    LSYLoadingHUD *hud = [[LSYLoadingHUD alloc] init];
    hud.backgroundColor = color;
    hud.topSpacesRatio = ratio;
    [hud showHUDText:text inViewController:(UIViewController *)self];
}

- (void)showCustomLoadingHUD {
    LSYLoadingHUD *hud = [[LSYLoadingHUD alloc] init];
    [hud showHUDText:@"Loading..." inViewController:(UIViewController *)self];
}

- (void)showCustomFailureHUDWith:(NSString *)text block:(void(^)(void))block {
    [LSYLoadingHUD failHUDText:text inViewController:(UIViewController *)self reload:block];
}

- (void)showCustomFailureHUDWith:(NSString *)text image:(NSString *)image block:(void(^)(void))block {
    [LSYLoadingHUD failHUDText:text inViewController:(UIViewController *)self reload:block];
}

- (void)dismissCustomLoadingHUD {
    [LSYLoadingHUD hiddenAllHUD:(UIViewController *)self];
}


#pragma mark - Associationl property

- (NSString *)progressTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setProgressTitle:(NSString *)progressTitle {
    objc_setAssociatedObject(self, @selector(progressTitle), progressTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)progressHUD {
    /**
     *  Objective-C的编译器在编译后会在每个方法中加两个隐藏的参数:
     *  1. _cmd，当前方法的一个SEL指针
     *  2. self，指向当前对象的一个指针
     */
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD {
    objc_setAssociatedObject(self, @selector(progressHUD), progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - No data view

- (void)showBlankView {
    exceptioning(@"未实现")
}

- (void)dismissBlankView {
    exceptioning(@"为实现")
}


#pragma mark -

- (void)setupRefreshWithTarget:(id)target head:(SEL)headerRefreshingHandler foot:(SEL)footerRefreshingHandler {
    if (class_equal(self, UITableView.class)) {
        exceptioning(@"没实现")
#if 0
        UITableView *tableView = (UITableView *)self;
        [tableView addHeaderWithTarget:target action:headerRefreshingHandler];
        [tableView addFooterWithTarget:target action:footerRefreshingHandler];
        
        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        tableView.headerPullToRefreshText = @"下拉刷新";
        tableView.headerReleaseToRefreshText = @"松开就可以刷新";
        tableView.headerRefreshingText = @"正在刷新";
        
        tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
        tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        tableView.footerRefreshingText = @"正在加载中";
#endif
    }
}

@end

#import "_pragma_pop.h"
