//
//  LocationService.h
//  hairdresser
//
//  Created by fallen.ink on 6/6/16.
//
//

#import "_service.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationModel.h"
#import "UserCityService.h"

typedef enum : NSUInteger {
    LocationStatus_NotStart,    //定位未开始
    LocationStatus_Locating,    //正在定位
    LocationStatus_Failed,      //定位失败
    LocationStatus_Success,     //定位成功
} LocationStatus;

@interface LocationService : _Service

@singleton( LocationService )

@prop_instance(UserCityService, userCityService)

@property (assign,nonatomic) LocationStatus locationStatus;

- (BOOL)isLocationComponentEnabled;

/**
 *  说明：
 *  LocationComponent用来定位当前用户所在位置（只有经纬度）或所在城市位置信息（既有经纬度又有城市信息）,即纯粹的地理定位，与用户的注册城市无任何关系。
 *  UserCityService用来存储用户注册城市相关的地理信息。
 */

//专注定位一百年，失败返回nil，不再返回默认城市或用户注册城市相关信息;优先使用高德逆地理编码，其次使用苹果的
- (void)currentLocationWithBlock:(void(^)(LocationModel* location))handlerBlock;

//立即返回当前的定位结果，位定位到的话为nil,慎用！！
- (LocationModel *)currentLocation;

//只取经纬度
- (void)currentSimpleLocationWithBlock:(void (^)(CLLocation *))handlerBlock;

@end

@namespace( service, location, LocationService )
