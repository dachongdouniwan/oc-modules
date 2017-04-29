//
//  UIViewController+.h
//  XFAnimations
//
//  Created by fallen.ink on 12/8/15.
//  Copyright © 2015 fallen.ink. All rights reserved.
//

#import "_precompile.h"

@interface UIViewController ( Extension )

- (id) _initWithNib;

/**
 *  Offen used with present view Controller who need display navigation bar.
 *
 *  @return UINavigationController instance using 'self' as rootViewController
 */
- (UINavigationController *)withNavigationController;

+ (instancetype)controller;
+ (instancetype)controllerWithNibName:(NSString *)nibName;
+ (UINavigationController *)navigationController;

@end

@interface UIViewController ( Template )

#pragma mark - Views operations: overrided if needed

- (void)initDefault;

- (void)initViews;

- (void)initNavigationBar;

- (void)initData;

- (void)initDataSource;

- (void)initScrollView;

- (void)initTableView;

- (void)initCollectionView;

- (void)initChildViewController;

/**
 *  当UIViewController有两种展示方式，则可以调用该策略view初始化
 */
- (void)initViewStrategy;

#pragma mark - Constraints operations: Need to be overrided

// mark template

#pragma mark - Initialize
#pragma mark - Life cycle
#pragma mark - Update
#pragma mark - Action handler && Notification handler &&
#pragma mark - ANY delegate
#pragma mark - Property
#pragma mark -

@end

#pragma mark -

@interface UIViewController ( Handler )

@property (nonatomic, strong, readonly) ErrorBlock failureHandler;

@end
