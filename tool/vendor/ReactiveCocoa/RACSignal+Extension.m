//
//  RACSignal+Extension.m
//  component
//
//  Created by 王涛 on 15/11/5.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import "RACSignal+Extension.h"
#import "RACSignal+Operations.h"
#import "RACScheduler.h"

@implementation RACSignal (Extension)

- (RACSignal *)onMainThread {
    return [self deliverOn:RACScheduler.mainThreadScheduler];
}

@end
