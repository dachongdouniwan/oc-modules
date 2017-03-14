//
//  AliPayOrder.m
//  consumer
//
//  Created by fallen.ink on 9/20/16.
//
//

#import "AliPayOrder.h"
#import "AliPayConfig.h"

#if 0 // Need 
#import "Order.h"
#import "DataSigner.h"
#endif

/**
 *  2016-09-19 19:02:28.865 consumer[43233:587374] -canOpenURL: failed for URL: "alipay://" - error: "(null)"
 *  2016-09-19 19:02:28.882 consumer[43233:587374] -canOpenURL: failed for URL: "cydia://" - error: "(null)"
 *  2016-09-19 19:02:28.883 consumer[43233:587374] -canOpenURL: failed for URL: "safepay://" - error: "(null)"
 *  2016-09-19 19:02:28:429 consumer[43233:587374] Notification 'notification.ComponentPayment.WAITTING'
 *  2016-09-19 19:02:29.018 consumer[43233:587374] -canOpenURL: failed for URL: "cydia://" - error: "(null)"
 *  2016-09-19 19:02:29.019 consumer[43233:587374] -canOpenURL: failed for URL: "safepay://" - error: "(null)"
 
 *  真机测试是OK的
 */

@implementation AliPayOrder

#if 0
- (NSString *)generate:(NSError **)ppError {
    Order *order = [Order new];
    
    order.partner   = [AliPayConfig sharedInstance].parnter;
    order.seller    = [AliPayConfig sharedInstance].seller;
    order.notifyURL = [AliPayConfig sharedInstance].notifyURL;
    
    order.showUrl   = [AliPayConfig sharedInstance].showURL;
    order.service   = [AliPayConfig sharedInstance].service;
    order.paymentType   = [AliPayConfig sharedInstance].paymentType;
    order.inputCharset  = [AliPayConfig sharedInstance].inputCharset;
    
    if (self.no && self.no.length) {
        order.tradeNO = self.no;
    } else {
        *ppError    = [self err_invalidOrderNumber];
        
        return nil;
    }
    
    if (self.name && self.name.length) {
        order.productName = self.name;
    } else {
        *ppError    = [self err_invalidProductName];
        
        return nil;
    }
    
    if (self.desc && self.desc.length) {
        order.productDescription = self.desc;
    } else {
        order.productDescription = @"unknown";
    }
    
    if (self.price && self.price.length) {
        order.amount = self.price;
    } else {
        order.amount = @"0.00";
    }
    
    if(self.outOfTime && self.outOfTime.length) {
        order.itBPay = self.outOfTime;  // 格式yyyy-MM-dd HH:mm:ss（5月26号后）
        // m-分钟，h－小时，d－天，1c－当天，范围：1m－15d （5月26号之前）
    }
    
    NSString *orderDesc = [order description];
    id<DataSigner> signer = CreateRSADataSigner([AliPayConfig sharedInstance].privateKey);
    
    NSString *signedString  = [signer signString:orderDesc];
    if (!signedString) {
        *ppError    = [self err_failedGenerateOrder];
        
        return nil;
    }
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderDesc, signedString, @"RSA"];
    if (!orderString ||
        !orderString.length ) {
        return nil;
    }
    
    return orderString;
}
#endif

- (NSString *)generate {
    return self.payUrl;
}

- (void)clear {
    self.no = nil;
    self.name = nil;
    self.desc = nil;
    self.price = nil;
}

#pragma mark - Error

@def_error_2( err_invalidOrderNumber, 1000, @"Invalid order number!" )
@def_error_2( err_invalidProductName, 1001, @"Invalid product name!" )
@def_error_2( err_failedGenerateOrder, 1002, @"failed to generate order string" )

@end
