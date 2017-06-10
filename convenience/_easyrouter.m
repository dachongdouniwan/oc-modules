//
//  NSObject+_easyrouter.m
//  OfficialDemo3D
//
//  Created by fallen.ink on 10/06/2017.
//  Copyright © 2017 songjian. All rights reserved.
//

#import "_easyrouter.h"

@implementation NSObject (_easyrouter)

- (void)router_setNavigationController:(UINavigationController *)controller {
    [[_Router sharedInstance] setNavigationController:controller];
}

- (void)router_register:(Class)c {
    [[_Router sharedInstance] map:classnameof_Class(c) toController:c];
}

- (void)router_open:(NSString *)url {
    [self router_open:url animate:YES extraParams:nil];
}

- (void)router_open:(NSString *)url animate:(BOOL)animate extraParams:(NSDictionary *)params {
    [[_Router sharedInstance] open:url animated:YES extraParams:params];
}

- (void)router_openExternal:(NSString *)url {
    [[_Router sharedInstance] openExternal:url];
}

- (void)router_push:(UIViewController *)controller {
    [[_Router sharedInstance]->route.navigationController pushViewController:controller animated:YES];
}

- (void)router_pop {
    [[_Router sharedInstance] pop];
}

- (void)router_popTo:(UIViewController *)controller {
    [[_Router sharedInstance]->route.navigationController popToViewController:controller animated:YES];
}

- (void)router_popTos:(NSString *)url {
    UIViewController *c = [[_Router sharedInstance]->route.navigationController viewControllerForClass:classify(url)];
    if (c) {
        [self router_popTo:c];
    }
}

#pragma mark - react native

- (void)rn_register:(Class)c {
    [[_Router sharedInstance] map:@"react-native default" toController:c];
}

- (void)rn_openWithExtraParams:(NSDictionary *)params {
    [[_Router sharedInstance] open:@"react-native default" animated:YES extraParams:params];
}

@end
