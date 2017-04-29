//
//  UIViewController+.m
//  XFAnimations
//
//  Created by fallen.ink on 12/8/15.
//  Copyright © 2015 fallen.ink. All rights reserved.
//

#import "UIViewController+.h"
#import "BaseNavigationController.h"
#import "_foundation.h"
#import "_system.h"
#import "_easycoding.h"

@implementation UIViewController ( Extension )

- (id) _initWithNib {
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (UINavigationController *)withNavigationController {
    return [[BaseNavigationController alloc] initWithRootViewController:self];
}

+ (instancetype)controller {
    return [self controllerWithNibName:NSStringFromClass([self class])];
}

+ (instancetype)controllerWithNibName:(NSString *)nibName {
    return [[self alloc] initWithNibName:nibName bundle:nil];
}

+ (UINavigationController *)navigationController {
    return [[BaseNavigationController alloc] initWithRootViewController:[self controller]];
}

@end

@implementation UIViewController ( Template )

- (void)initDefault {
    
}

- (void)initViews {
    
}

- (void)initNavigationBar {
    
}

- (void)initData {
    
}

- (void)initDataSource {
    
}

- (void)initScrollView {
    
}

- (void)initTableView {
    
}

- (void)initCollectionView {
    
}

- (void)initChildViewController {
    
}

- (void)initViewStrategy {
    
}

@end

#pragma mark -

@implementation UIViewController ( Handler )

- (ErrorBlock)failureHandler {
    @weakify(self)
    
    return ^(NSError *error) {
        
        @strongify(self)
        
        [self showAlertView:@"数据加载失败" message:error.message cancelButtonName:@"确定" cancelHandler:^{
            @strongify(self)
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    };
}

@end

