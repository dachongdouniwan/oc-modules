//
//  GrowthCache.m
//  consumer
//
//  Created by 张衡的mini on 16/12/26.
//
//

#import "GrowthCache.h"

@implementation Growth

@end

@implementation GrowthCache

@def_singleton( GrowthCache )

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSArray *)allObjects{
    RLMResults *results = [Growth allObjects];
    NSMutableArray * allObjects = [[NSMutableArray alloc] init];
    for (int i = 0; i < results.count; i ++) {
        [allObjects addObject:[results objectAtIndex:i]];
    }
    return allObjects;
}

- (NSInteger)allObjectsCount {
    RLMResults *results = [Growth allObjects];
    return results.count;
}

- (void)addObject:(RLMObject *)obj {
    RLMRealm *realm = [RLMRealm defaultRealm];
    //开放RLMRealm事务
    [realm beginWriteTransaction];
    //添加到数据库 为RLMObject
    [realm addObject:obj];
    //提交事务
    [realm commitWriteTransaction];
}

- (void)removeAllObject {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

@end
