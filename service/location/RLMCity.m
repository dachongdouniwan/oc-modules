//
//  RLMCity.m
//  component
//
//  Created by pad on 16/4/13.
//  Copyright © 2016年 OpenTeam. All rights reserved.
//

#import "RLMCity.h"

@implementation City

@end

@interface CityCache ()

@end

@implementation CityCache

@def_singleton( CityCache )

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSArray *)allObjects{
    RLMResults *results = [City allObjects];
    NSMutableArray * allObjects = [[NSMutableArray alloc] init];
    for (int i = 0; i < results.count; i ++) {
        [allObjects addObject:[results objectAtIndex:i]];
    }
    return allObjects;
}

- (void)addObjects:(NSMutableArray *)objs {
    RLMRealm *realm = [RLMRealm defaultRealm];
    //开放RLMRealm事务
    [realm beginWriteTransaction];
    //添加到数据库 为RLMObject
    for (int i = 0; i < objs.count; i ++) {
        [realm addObject:[objs objectAtIndex:i]];
    }
    //提交事务
    [realm commitWriteTransaction];
}

- (int)idForName:(NSString *)name {
    RLMResults *cities = [City objectsWhere:@"name = %@", name];
    if (cities.count) {
        City *city = cities.lastObject;
        return city.id;
    }
    return -1;
}

- (NSString *)citynameForID:(int)ID withDefault:(NSString *)defaultName {
    RLMResults *cities = [City objectsWhere:@"id = %lld", ID];
    if (cities.count) {
        City *city = cities.lastObject;
        return city.name;
    }
    return defaultName;
}

- (int)cityIdForCityCode:(int)code{
    RLMResults *cities = [City objectsWhere:@"code = %d", code];
    if (cities.count) {
        City *city = cities.lastObject;
        return city.id;
    }
    return -1;
}

- (id)objectForId:(long long)id_ {
    RLMResults *cities = [City objectsWhere:@"code = %lld", id_];
    if (cities.count) {
        City *city = cities.lastObject;
        return city;
    }
    return nil;
}

- (NSMutableArray *)objectsWithPredicate:(NSPredicate *)predicate {
    RLMResults *results = [City objectsWithPredicate:predicate];
    NSMutableArray *cities = [NSMutableArray new];
    
    for (int i = 0; i < results.count; i++) {
        [cities addObject:[results objectAtIndex:i]];
    }
    
    return cities;
}

- (void)removeAllObject {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}
@end
