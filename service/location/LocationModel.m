//
//  LocationModel.m
//  component
//
//  Created by 郭晓倩 on 15/10/26.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LocationModel.h"

#define kCodeKeyAddress     @"address"
#define kCodeKeyLatitude    @"latitude"
#define kCodeKeyLongitude   @"longitude"
#define kCodeKeyCityId      @"cityId"
#define kCodeKeyCityName    @"cityName"
#define kCodeKeyDistrict    @"district"
#define kCodeKeyCityCode   @"cityCode"
@implementation LocationModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.address = [aDecoder decodeObjectForKey:kCodeKeyAddress];
        self.latitude = [aDecoder decodeDoubleForKey:kCodeKeyLatitude];
        self.longitude = [aDecoder decodeDoubleForKey:kCodeKeyLongitude];
        self.cityID = [aDecoder decodeIntForKey:kCodeKeyCityId];
        self.cityCode = [aDecoder decodeIntForKey:kCodeKeyCityCode];
        self.cityNameString = [aDecoder decodeObjectForKey:kCodeKeyCityName];
        self.district = [aDecoder decodeObjectForKey:kCodeKeyDistrict];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.address forKey:kCodeKeyAddress];
    [aCoder encodeDouble:self.latitude forKey:kCodeKeyLatitude];
    [aCoder encodeDouble:self.longitude forKey:kCodeKeyLongitude];
    [aCoder encodeInt:self.cityID forKey:kCodeKeyCityId];
    [aCoder encodeObject:self.cityNameString forKey:kCodeKeyCityName];
    [aCoder encodeObject:self.district forKey:kCodeKeyDistrict];
    [aCoder encodeInt:self.cityCode forKey:kCodeKeyCityCode];
}


+ (id)modelWithLongitude:(double)lo latitude:(double)la {
    return [LocationModel modelWithAddress:@"" longitude:lo latitude:la];
}

+ (id)modelWithAddress:(NSString *)addr longitude:(double)lo latitude:(double)la {
    LocationModel *m = [LocationModel new];
    m.address = addr;
    m.longitude = lo;
    m.latitude = la;
    return m;
}

+ (double)kilometerDistanceBetween:(LocationModel *)aLocation and:(LocationModel *)bLocation{
    //根据经纬度创建两个位置对象
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:aLocation.latitude
                                                  longitude:aLocation.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:bLocation.latitude
                                                  longitude:bLocation.longitude];
    
    //计算两个位置之间的距离
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    return distance/1000;
}

-(id)copyWithZone:(NSZone*)zone{
    LocationModel* copy = [[[self class] allocWithZone:zone] init];
    
    copy.latitude = self.latitude;
    copy.longitude = self.longitude;
    copy.cityID = self.cityID;
    copy.cityCode = self.cityCode;
    copy.cityNameString = self.cityNameString;
    
    return copy;
}

- (double)kilometerDistanceTo:(LocationModel *)thatLocation {
    return [LocationModel kilometerDistanceBetween:self and:thatLocation];
}

- (BOOL)isValid{
    return [self containValidCity] && [self containValidLocation];
}

- (BOOL)containValidCity{
    return (self.cityID >= 0 && [self.cityNameString length] > 0);
}

- (BOOL)containValidLocation{
    return (self.longitude >= -180 && self.longitude <= 180 && self.latitude >= -90 && self.latitude <= 90);
}

//- (BOOL)isEqualToLocationModel:(LocationModel*)locationModel{
//    return locationModel && self.latitude == locationModel.latitude && self.longitude == locationModel.longitude;
//}
//- (BOOL)isEqualToUserAddress:(UserAddress*)userAddress{
//    return userAddress && self.latitude == userAddress.latitude && self.longitude == userAddress.longitude;
//}

-(NSString*)description{
    return [NSString stringWithFormat:@"地址:%@ 城市ID:%d 经纬度:(%f,%f)",self.address,self.cityID,self.longitude,self.latitude];
}

@end
