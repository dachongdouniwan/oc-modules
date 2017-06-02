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

@interface LocationService () <CLLocationManagerDelegate> {
    
}

@prop_strong(AMapLocationManager *, locationManager)

@prop_strong(CLLocation *, currrentSimLocation)

@end

@implementation LocationService

@def_singleton( LocationService )

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

- (BOOL)available {
#if TARGET_IPHONE_SIMULATOR
    WARN(@"定位服务.模拟器环境下定位不可用");
    return NO;
#else
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        WARN(@"定位服务.未开启定位服务");
        return NO;
    }
    return YES;
#endif
}

- (void)currentLocationWithBlock:(void(^)(LocationModel* location))handlerBlock {
    NSAssert(handlerBlock != nil, @"定位服务.未提供回调block");
    
    if (self.currentLocation) {
        handlerBlock(self.currentLocation);
    } else if(![self available]) {
        self.locationStatus = LocationStatus_Failed;
        handlerBlock(nil);
    } else {
        [self updateLocationWithBlock:handlerBlock];
    }
}

- (void)updateLocationWithBlock:(void(^)(LocationModel* location))handlerBlock {
    self.locationStatus = LocationStatus_Locating;
    //偏差在100米以内，耗时在2-3s
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        if(location == nil && regeocode == nil){
            if (error) {
                ERROR(@"定位服务.定位失败,error:{%ld - %@}", (long)error.code, error.localizedDescription);
                
            } else {
                ERROR(@"定位服务.定位失败");
                
            }
            self.locationStatus = LocationStatus_Failed;
            handlerBlock(nil);
            return;
        } else if(location) {
            self.currrentSimLocation = location;
            
            if (regeocode) {
                LocationModel* locationResult = [LocationModel new];
                int cityID = regeocode.citycode.intValue;
                
                if (cityID) {
                    locationResult.latitude = location.coordinate.latitude;
                    locationResult.longitude = location.coordinate.longitude;
                    locationResult.cityId = cityID;
                    locationResult.cityCode = cityID;
                    locationResult.address = regeocode.formattedAddress;
                    locationResult.district = regeocode.district;
                    locationResult.cityName = regeocode.city ? regeocode.city : regeocode.province;
                    
                    self.currentLocation = locationResult;
                    self.locationStatus = LocationStatus_Success;
                    
                    handlerBlock(locationResult);
                    return ;
                }
            }
            
            [CityGeoCoder reverseGeocodeLocation:location completionHandler:^(LocationModel *locationResult) {
                if (locationResult) {
                    self.currentLocation = locationResult;
                    
                    self.locationStatus = LocationStatus_Success;
                } else {
                    
                    self.locationStatus = LocationStatus_Failed;
                }
                
                handlerBlock(locationResult);
                return;
            }];
        } else {
            ERROR(@"定位服务.定位失败");
            self.locationStatus = LocationStatus_Failed;
            handlerBlock(nil);
            return;
        }
    }];
}

#pragma mark - 只定位经纬度

- (void)currentSimpleLocationWithBlock:(void (^)(CLLocation *))handlerBlock {
    NSAssert(handlerBlock != nil, @"定位服务.未提供回调block");
    
    if (self.currrentSimLocation) {
        handlerBlock(self.currrentSimLocation);
    } else if(![self available]) {
        handlerBlock(nil);
    } else {
        [self updateSimpleLocationWithBlock:handlerBlock];
    }
}

- (void)updateSimpleLocationWithBlock:(void(^)(CLLocation* location))handlerBlock {
    //偏差在100米以内，耗时在2-3s
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        
        if(location == nil) {
            if (error) {
                ERROR(@"定位服务.简单定位失败,error:{%ld - %@}", (long)error.code, error.localizedDescription);
                
            } else {
                ERROR(@"定位服务.简单定位失败");
            }
            
            handlerBlock(nil);
            
            return;
        } else if(location) {
            self.currrentSimLocation = location;
            handlerBlock(location);
            return;
        } else {
            
            ERROR(@"定位服务.简单定位失败");
            
            handlerBlock(nil);
            
            return;
        }
    }];
}

@end

@def_namespace( service, location, LocationService )
