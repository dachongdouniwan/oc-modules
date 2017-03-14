//
//  GrowthCache.h
//  consumer
//
//  Created by 张衡的mini on 16/12/26.
//
//

#import <Foundation/Foundation.h>
#import "_greats.h"
#import "_vendor_realm.h"

@interface Growth : RLMObject

@property int id;
@property NSInteger time;
@property int viewid;
@property double longitude;
@property double latitude;

@end

RLM_ARRAY_TYPE(Growth)

@interface GrowthCache : NSObject // todo: 应该模仿RLM_ARRAY_TYPE，搞一个CacheProtocol，然后，用宏来定义

@singleton( GrowthCache )

- (void)addObject:(RLMObject *)obj;

- (void)removeAllObject;

- (NSArray *)allObjects;

- (NSInteger)allObjectsCount;

@end
