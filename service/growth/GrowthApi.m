//
//  GrowthApi.m
//  consumer
//
//  Created by 张衡的mini on 16/12/27.
//
//

#import "GrowthApi.h"

@implementation GrowthApi

@end

@implementation UpLoadGrowthRequest

- (NSString *)buildUrl {
    return @"http://log.yizi.com/log/uploadAndroid";
}

impl_net_request_sim(@"", @"UpLoadGrowthResponse")

@end

@implementation UpLoadGrowthResponse

@end
