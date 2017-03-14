//
//  UserCityService.h
//  component
//
//  Created by on 15/10/26.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//
// 用户注册城市本地存储(使用UserDefault)

#import "_greats.h"
#import "LocationModel.h"

extern NSString * const kDefaultUserCityName;

@interface UserCityService : NSObject

@singleton( UserCityService )

- (NSString *)getUserCityName;
- (NSNumber *)getUserCityId;
- (NSString *)getUserCityNameWithDefault;
- (NSNumber *)getUserCityIdWithDefault;

//存储用户城市
- (void)updateUserCityName:(NSString*)cityName;
- (void)updateUserCityId:(NSNumber*)cityId;
//获取城市中心经纬度
- (void)getUserCityLocation:(void(^)(LocationModel *location))handlerBlock;
//默认城市为上海
- (LocationModel *)defaultUserCityLocation;

@end
