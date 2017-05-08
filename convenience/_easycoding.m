//
//  NSObject+Easy.m
//  component
//
//  Created by fallen.ink on 4/14/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <objc/runtime.h>
#import "SVProgressHUD.h"
#import "AlertView.h"
#import "UIView+Extension.h"
#import "_foundation.h"
#import "_easycoding.h"
#import "_ui_component.h"
#import "_pragma_push.h"

/**
 *  1. HUD 透明显示层
 
    https://github.com/SVProgressHUD/SVProgressHUD/tree/master/SVProgressHUD
 */


@interface NSObject ()

@property (nonatomic, strong) NSString *progressTitle;

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

- (void)hideActivityHUD {
    [SVProgressHUD dismiss];
}

- (void)showActivityHUD {
    [SVProgressHUD show];
}

#pragma mark - Toast

- (void)showToastWithText:(NSString *)text {
    [FTIndicator showToastMessage:text];
}

#pragma mark -

- (void)showAlertView:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)name cancelHandler:(Block)cancelHandler {
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

#pragma mark - Associationl property

- (NSString *)progressTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setProgressTitle:(NSString *)progressTitle {
    objc_setAssociatedObject(self, @selector(progressTitle), progressTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
