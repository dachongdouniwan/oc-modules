//
//  UserCityService.m
//  component
//
//  Created by on 15/10/26.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import "_vendor_lumberjack.h"
#import "_cache.h"
#import "UserCityService.h"
#import "CityGeoCoder.h"
#import "RLMCity.h"

const int kNoCityID = -1;

static NSString *kUDUserCityName = @"UserCityName";
static NSString *kUDUserCityId = @"UserCityId";
static NSString *UserCityCode = @"UserCityCode";
static NSString *kUDUserCityLatitude = @"UserCityLatitude";
static NSString *kUDUserCityLongitude = @"UserCityLongitude";

NSString * const kDefaultUserCityName = @"上海";
const int kDefaultUserCityId = 4;//上海
const double kDefaultUserCityLatitude = 31.22;
const double kDefaultUserCityLongitude = 121.48;

@interface UserCityService ()

@property (strong, nonatomic) LocationModel *userCityLocation;

@end

@implementation UserCityService

@def_singleton( UserCityService )

#pragma mark - 城市名

- (NSString *)getUserCityName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUDUserCityName];
}

- (NSNumber *)getUserCityId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUDUserCityId];
}

- (NSString *)getUserCityNameWithDefault {
    NSString* cityName = [self getUserCityName];
    if (!cityName) {
        cityName = kDefaultUserCityName;
    }
    return cityName;
}
- (NSNumber *)getUserCityIdWithDefault {
    NSNumber* cityId = [self getUserCityId];
    if (!cityId) {
        cityId = @(kDefaultUserCityId);
    }
    return cityId;
}

- (void)updateUserCityName:(NSString *)cityName {
    if(cityName.length <= 0){
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kUDUserCityName];
    
    //先存一下城市ID，以免地理编码失败时丢失信息
    __block NSNumber *cityId = nil;
    cityId = @([[CityCache sharedInstance] idForName:cityName]);
    if (cityId && cityId.intValue > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:cityId forKey:kUDUserCityId];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateUserCityLocation:nil];
}

- (void)updateUserCityId:(NSNumber *)cityId {
    if(!cityId || cityId.intValue <= 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cityId forKey:kUDUserCityId];
}

#pragma mark - 城市位置

- (void)getUserCityLocation:(void (^)(LocationModel *))handlerBlock{
    
    NSAssert(handlerBlock != nil, @"用户城市服务.获取用户城市定位.未提供回调block");
    
    if (_userCityLocation == nil) {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:kUDUserCityName];
        NSNumber *cityId = [userDefaults objectForKey:kUDUserCityId];
        NSNumber* cityLatitude =[userDefaults objectForKey:kUDUserCityLatitude];
        NSNumber* cityLongitude =[userDefaults objectForKey:kUDUserCityLongitude];
        if (cityName && cityId && cityLatitude && cityLongitude) {
            LocationModel* cityLocation = [LocationModel new];
            cityLocation.cityNameString = cityName;
            cityLocation.cityID = cityId.intValue;
            cityLocation.latitude = cityLatitude.doubleValue;
            cityLocation.longitude = cityLongitude.doubleValue;
            _userCityLocation = cityLocation;
            
            [main_queue queueBlock:^{
                handlerBlock(cityLocation);
            }];
        } else {
            [self updateUserCityLocation:^(LocationModel *location) {
                if (location && [location containValidCity]) {
                    _userCityLocation = location;
                    [main_queue queueBlock:^{
                        handlerBlock(location);
                    }];
                } else {
                    DDLogWarn(@"定位服务.获取注册城市定位失败");
                    _userCityLocation = nil;
                    [main_queue queueBlock:^{
                        handlerBlock(nil);
                    }];
                }
            }];
        }
    } else {
        [main_queue queueBlock:^{
            handlerBlock(_userCityLocation);
        }];
    }
}

- (void)updateUserCityLocation:(void(^)(LocationModel* location))handlerBlock {
    NSString *cityName = [self getUserCityName];
    
    if(cityName == nil) {
        if (handlerBlock) {
            handlerBlock(nil);
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [CityGeoCoder geocodeAddressString:cityName completionHandler:^(LocationModel *location) {
            if (location) {
                //存储本地
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSNumber numberWithInt:location.cityID] forKey:kUDUserCityId];
                [userDefaults setObject:[NSNumber numberWithDouble:location.latitude] forKey:kUDUserCityLatitude];
                [userDefaults setObject:[NSNumber numberWithDouble:location.longitude] forKey:kUDUserCityLongitude];
                [userDefaults synchronize];
                
                weakSelf.userCityLocation = location;
            }
            
            if (handlerBlock) {
                handlerBlock(location);
            }
        }];
    }
}

#pragma mark - 默认用户城市

- (LocationModel*)defaultUserCityLocation {
    LocationModel* cityLocation = [LocationModel new];
    
    cityLocation.cityID = kDefaultUserCityId;
    cityLocation.cityNameString = kDefaultUserCityName;
    cityLocation.latitude = kDefaultUserCityLatitude;
    cityLocation.longitude = kDefaultUserCityLongitude;
    cityLocation.address = kDefaultUserCityName;
    
    return cityLocation;
}

#pragma mark - Property

- (NSString *)userCityCode {
    return _cache_[UserCityCode];
}

- (void)setUserCityCode:(NSString *)userCityCode {
    if (is_string_present(userCityCode)) {
        _cache_[UserCityCode] = userCityCode;
    }
}


@end
