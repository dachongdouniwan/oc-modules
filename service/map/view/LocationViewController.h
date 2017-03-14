//
//  LocationViewController.h
//  QQing
//
//  Created by 李杰 on 1/27/15.
//
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "BaseViewController.h"

typedef enum : NSUInteger {
    SelectAddressType_Default,
} SelectAddressType;

@class LocationModel;

@interface LocationViewController : BaseViewController

/**
 *  选择地址
 *  @param type  使用情景类型
 *  @param block 回调LocationModel
 */
- (instancetype)initWithSelectAddressType:(SelectAddressType)type completionBlock:(ObjectBlock)block;

@end

#pragma mark -

@interface NSString (QQ)

/**
 *  拼接-大概地址+特殊符号+详细地址  夹杂特殊符号&
 */
- (NSString *)joinDetailAddress:(NSString *)detailAddress;

/**
 *  将地址分离，供不同地址框显示
 */
- (NSArray *)separateDetailAddress;

/**
 *  去除特殊符号在常用地址列表显示
 */
- (NSString *)resignDetalAddress;

@end
