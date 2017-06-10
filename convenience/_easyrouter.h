//
//  NSObject+_easyrouter.h
//  OfficialDemo3D
//
//  Created by fallen.ink on 10/06/2017.
//  Copyright © 2017 songjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_router.h"
#import "BaseViewController.h"

@interface NSObject (_easyrouter)

- (void)router_setNavigationController:(UINavigationController *)controller;

/**
 *  Register view contoller to router
 *
 *  @param c Class of the view controller
 */
- (void)router_register:(Class)c;

/**
 *  Open view controller
 *
 *  @param url unique url of view Controller (like class name)
 */
- (void)router_open:(NSString *)url;

/**
 *  Open view controller
 *
 *  @param url unique url of view Controller (like class name)
 *  @param animate   animate
 *  @param params    extra params
 */
- (void)router_open:(NSString *)url animate:(BOOL)animate extraParams:(NSDictionary *)params;

/**
 *  Open out link
 *
 *  @param url link
 */
- (void)router_openExternal:(NSString *)url;

/**
 *  Open view controller without param cache
 *
 *  @param controller controller
 */
- (void)router_push:(UIViewController *)controller;

/**
 *  Pop the last view (controller)
 */
- (void)router_pop;

/**
 *  Pop to the exactly view, MUST be in the sample navigation route
 */
- (void)router_popTo:(UIViewController *)controller;

/**
 *  Pop to the exactly view, MUST be in the sample navigation route
 *
 *  @param url unique url of a view page
 */
- (void)router_popTos:(NSString *)url;

#pragma mark - react native

/**
 *  权宜之计
 *
 *  @param c class of a view page
 */
- (void)rn_register:(Class)c;

/**
 *  Open react native vc with extra params
 *
 *  @param params all the params the client wanna pass to
 
 *  Basic key value define
 
 *  'url'       url to init RCTRootView
 *  'title'     title of View Controller
 *  'param'     param to init react view
 *  'module'    module name to load react view
 */
- (void)rn_openWithExtraParams:(NSDictionary *)params;

@end

#pragma mark - Router adapter

@interface BaseViewController ()

@property (nonatomic, strong) NSDictionary *params;

- (instancetype)initWithRouterParams:(NSDictionary *)params;

@end
