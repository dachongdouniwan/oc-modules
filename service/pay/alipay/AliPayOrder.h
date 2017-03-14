//
//  AliPayOrder.h
//  consumer
//
//  Created by fallen.ink on 9/20/16.
//
//

#import "_greats.h"

@interface AliPayOrder : NSObject

@property (nonatomic, strong) NSString *no;         // 订单ID（由商家自行制定）
@property (nonatomic, strong) NSString *name;       // 商品标题
@property (nonatomic, strong) NSString *desc;       // 商品描述
@property (nonatomic, strong) NSString *price;      // 商品价格
@property (nonatomic, strong) NSString *outOfTime;

//- (NSString *)generate:(NSError **)ppError;

- (void)clear;

#pragma mark - Error

@error( err_invalidOrderNumber )
@error( err_invalidProductName )
@error( err_failedGenerateOrder )

/**
 *  @desc 当前工程内实现，只关注下面参数
 */
@property (nonatomic, strong) NSString *payUrl;

- (NSString *)generate;

@end
