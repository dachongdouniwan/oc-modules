//
//  LocationService.m
//  hairdresser
//
//  Created by fallen.ink on 6/6/16.
//
//

#import "_vendor_lumberjack.h"
#import "LocationService.h"
#import "CityGeoCoder.h"
#import "_vendor_reactivecocoa.h"
#import "AMapLocationKit/AMapLocationKit.h"

const int kUpdateLocationInterval = 1*60;//每1分钟刷新定位

@interface LocationService () <CLLocationManagerDelegate>

@property (strong, nonatomic) AMapLocationManager *gdLocationManager;

@property (strong, atomic) LocationModel    *curLocation;
@property (strong, atomic) CLLocation   *curSimpleLocation;

@end

@implementation LocationService

@def_singleton( LocationService )

@def_prop_instance( UserCityService, userCityService )

- (instancetype)init {
    if (self = [super init]) {
        self.locationStatus = LocationStatus_NotStart;
        
#if !TARGET_OS_SIMULATOR
            //高德定位服务
            self.gdLocationManager = [AMapLocationManager new];
            
            //定时自动更新定位
            [[[RACSignal interval:kUpdateLocationInterval onScheduler:[RACScheduler mainThreadScheduler]] delay:kUpdateLocationInterval]subscribeNext:^(id x) {
                [self updateLocationWithBlock:^(LocationModel *location) {
                    
                }];
            }];
            //首次获取定位
            [self currentLocationWithBlock:^(LocationModel *location) {
                
            }];
#endif
    }
    
    return self;
}

#pragma mark - 获取定位接口

- (BOOL)isLocationComponentEnabled {
#if TARGET_IPHONE_SIMULATOR
    DDLogWarn(@"定位服务.模拟器环境下定位不可用");
    return NO;
#else
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        DDLogWarn(@"定位服务.未开启定位服务");
        return NO;
    }
    return YES;
#endif
}

- (void)currentLocationWithBlock:(void(^)(LocationModel* location))handlerBlock {
    NSAssert(handlerBlock != nil, @"定位服务.未提供回调block");
    
    if (self.curLocation) {
        handlerBlock(self.curLocation);
    } else if(![self isLocationComponentEnabled]) {
        self.locationStatus = LocationStatus_Failed;
        handlerBlock(nil);
    } else {
        [self updateLocationWithBlock:handlerBlock];
    }
}

- (nullable LocationModel*)currentLocation{
    return self.curLocation;
}

- (void)updateLocationWithBlock:(void(^)(LocationModel* location))handlerBlock {
    self.locationStatus = LocationStatus_Locating;
    //偏差在100米以内，耗时在2-3s
    [self.gdLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    @weakify(self);
    [self.gdLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        if(location == nil && regeocode == nil){
            if (error) {
                DDLogError(@"定位服务.定位失败,error:{%ld - %@}", (long)error.code, error.localizedDescription);
                
            } else {
                DDLogError(@"定位服务.定位失败");
                
            }
            self.locationStatus = LocationStatus_Failed;
            handlerBlock(nil);
            return;
        } else if(location) {
            self.curSimpleLocation = location;
            
            if (regeocode) {
                LocationModel* locationResult = [LocationModel new];
                int cityID = regeocode.citycode.intValue;
                
                if (cityID) {
                    locationResult.latitude = location.coordinate.latitude;
                    locationResult.longitude = location.coordinate.longitude;
                    locationResult.cityID = cityID;
                    locationResult.cityCode = cityID;
                    locationResult.address = regeocode.formattedAddress;
                    locationResult.district = regeocode.district;
                    locationResult.cityNameString = regeocode.city ? regeocode.city : regeocode.province;
                    
                    self.curLocation = locationResult;
                    self.locationStatus = LocationStatus_Success;
                    
                    handlerBlock(locationResult);
                    return ;
                }
            }
            
            [CityGeoCoder reverseGeocodeLocation:location completionHandler:^(LocationModel *locationResult) {
                if (locationResult) {
                    self.curLocation = locationResult;
                    
                    self.locationStatus = LocationStatus_Success;
                } else {
                    
                    self.locationStatus = LocationStatus_Failed;
                }
                
                handlerBlock(locationResult);
                return;
            }];
        } else {
            DDLogError(@"定位服务.定位失败");
            self.locationStatus = LocationStatus_Failed;
            handlerBlock(nil);
            return;
        }
    }];
}

#pragma mark - 只定位经纬度

- (void)currentSimpleLocationWithBlock:(void (^)(CLLocation *))handlerBlock {
    NSAssert(handlerBlock != nil, @"定位服务.未提供回调block");
    
    if (self.curSimpleLocation) {
        handlerBlock(self.curSimpleLocation);
    } else if(![self isLocationComponentEnabled]) {
        handlerBlock(nil);
    } else {
        [self updateSimpleLocationWithBlock:handlerBlock];
    }
}

- (void)updateSimpleLocationWithBlock:(void(^)(CLLocation* location))handlerBlock {
    //偏差在100米以内，耗时在2-3s
    [self.gdLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    @weakify(self);
    [self.gdLocationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        
        if(location == nil) {
            if (error) {
                DDLogError(@"定位服务.简单定位失败,error:{%ld - %@}", (long)error.code, error.localizedDescription);
                
            } else {
                DDLogError(@"定位服务.简单定位失败");
                
            }
            handlerBlock(nil);
            return;
        } else if(location) {
            self.curSimpleLocation = location;
            handlerBlock(location);
            return;
        } else {
            DDLogError(@"定位服务.简单定位失败");
            handlerBlock(nil);
            return;
        }
    }];
}

@end

@def_namespace( service, location, LocationService )
