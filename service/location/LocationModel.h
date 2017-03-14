//
//  LocationModel.h
//  component
//
//  Created by 郭晓倩 on 15/10/26.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString * address;

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) int cityID;
@property (nonatomic, strong) NSString* cityNameString;
@property (nonatomic, strong) NSString* district;   //区，比如浦东新区
@property (nonatomic, assign) int cityCode;

+ (id)modelWithLongitude:(double)lo latitude:(double)la;

+ (id)modelWithAddress:(NSString *)addr longitude:(double)lon latitude:(double)lat;

+ (double)kilometerDistanceBetween:(LocationModel *)aLocation and:(LocationModel *)bLocation;

- (double)kilometerDistanceTo:(LocationModel *)thatLocation;

- (BOOL)isValid;
//是否包含有效的城市信息
- (BOOL)containValidCity;
//是否包含有效的定位信息
- (BOOL)containValidLocation;

//- (BOOL)isEqualToLocationModel:(LocationModel*)locationModel;
//- (BOOL)isEqualToUserAddress:(UserAddress*)address;

@end
