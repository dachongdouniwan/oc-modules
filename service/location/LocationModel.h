//
//  LocationModel.h
//  component
//
//  Created by 郭晓倩 on 15/10/26.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_archiver.h"

@interface LocationModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) double longitude; // 经度
@property (nonatomic, assign) double latitude; // 纬度

@property (nonatomic, assign) int cityID;
@property (nonatomic, assign) int cityCode;

@property (nonatomic, strong) NSString  *cityNameString;
@property (nonatomic, strong) NSString  *district;   //区，比如浦东新区

//
+ (id)modelWithLongitude:(double)lo latitude:(double)la;
+ (id)modelWithAddress:(NSString *)addr longitude:(double)lon latitude:(double)lat;

// 工具方法
+ (double)kilometerDistanceBetween:(LocationModel *)aLocation and:(LocationModel *)bLocation;
- (double)kilometerDistanceTo:(LocationModel *)thatLocation;
- (BOOL)isValid;

- (BOOL)containValidCity; //是否包含有效的城市信息
- (BOOL)containValidLocation; //是否包含有效的定位信息

@end
