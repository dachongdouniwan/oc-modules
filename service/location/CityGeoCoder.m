//
//  CityGeoCoder.m
//  component
//
//  Created by 郭晓倩 on 15/10/26.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import "_greats.h"
#import "_vendor_lumberjack.h"
#import "CityGeoCoder.h"
#import "RLMCity.h"

@implementation CityGeoCoder

+ (NSString *)cityNameWithID:(int)ID{
    NSString *cityName;// = [[RLMCityCache sharedInstance] citynameForID:ID defaultName:@"未找到"];
    return cityName;
}

+ (NSNumber *)cityIDWithName:(NSString *)name{
    NSNumber *cityID = @([[CityCache sharedInstance] idForName:name]);
    return cityID;
}

+ (void)geocodeAddressString:(NSString *)addressString completionHandler:(CityGeoCodeCompletionBlock)completionHandler{
    CLGeocoder * geoDecoder = [CLGeocoder new];
    [geoDecoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        BOOL success = NO;
        LocationModel* locationResult = [LocationModel new];
        
        if (!error) {
            CLPlacemark* placemark = [placemarks lastObject];
            NSNumber* cityID = [self cityIDWithName:placemark.name];
            if (cityID) {
                locationResult.cityID = [cityID intValue];
                locationResult.cityNameString = [self cityNameWithID:[cityID intValue]];
                locationResult.address = addressString;
                locationResult.district = placemark.subLocality;
                locationResult.latitude = placemark.location.coordinate.latitude;
                locationResult.longitude = placemark.location.coordinate.longitude;
                success = YES;
                DDLogDebug(@"定位服务.地理正编码成功（城市名-->经纬度:（%@ --> %@）",addressString,placemark.location);
            }
        }else{
            DDLogError(@"定位服务.地理正编码失败（城市名-->经纬度） error = %@", error);
        }
        
        if (!success) {
            locationResult = nil;
        }
        
        if (completionHandler) {
            completionHandler(locationResult);
        }
    }];
}

+ (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CityGeoCodeCompletionBlock)completionHandler{
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        BOOL success = NO;
        LocationModel* locationResult = [LocationModel new];
        
        if (!error) {
            for (CLPlacemark * placemark in placemarks) {
                NSString *cityStr = placemark.locality;
                if ([cityStr length] > 0) {
//                    NSNumber* cityID = [self cityIDWithName:cityStr];
//                    if (cityID) {
                        locationResult.latitude = location.coordinate.latitude;
                        locationResult.longitude = location.coordinate.longitude;
//                        locationResult.cityID = [cityID intValue];
                        locationResult.cityNameString = cityStr;//[self cityNameWithID:[cityID intValue]];
                        NSString *districtStr = placemark.subLocality;
                        NSString *streetStr = placemark.thoroughfare;
                        NSString *streetNumberStr = placemark.subThoroughfare;
                        NSMutableString* formatAddress = [NSMutableString stringWithString:cityStr];

                        if (districtStr) {
                            [formatAddress appendString:districtStr];
                        }
                        if (streetStr) {
                            [formatAddress appendString:streetStr];
                        }
                        if (streetNumberStr) {
                            [formatAddress appendString:streetNumberStr];
                        }
                        locationResult.address = formatAddress;
                        locationResult.district = districtStr;
                        
                        success = YES;
                        DDLogDebug(@"定位服务.地理逆编码成功（经纬度-->地址）:（%@ --> %@）",location, locationResult.address);
                        break;
//                    }
                }
            }
        }else{
            DDLogError(@"定位服务.地理逆编码（经纬度-->地址）失败，error = %@", error);
        }
        
        if (!success) {
            locationResult = nil;
        }
        
        if (completionHandler) {
            completionHandler(locationResult);
        }
    }];
}

@end
