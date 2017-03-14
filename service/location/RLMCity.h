//
//  RLMCity.h
//  component
//
//  Created by pad on 16/4/13.
//  Copyright © 2016年 OpenTeam. All rights reserved.
//

#import "_vendor_realm.h"
#import "_greats.h"

@interface City : RLMObject

@property int id;
@property (nonatomic, strong) NSString *name;
@property int code;
@property BOOL isOpen;

@end

RLM_ARRAY_TYPE(City)

// RLMCityCache

@interface CityCache : NSObject

@singleton( CityCache )

- (void)addObjects:(NSMutableArray *)objs;

- (NSArray *)allObjects;

/**
 *  根据 城市名 获取 城市ID
 *
 *  @param name 城市名
 *
 *  @return 城市ID, return -1 when none found.
 */
- (int)idForName:(NSString *)name;

/**
 *  根据 城市ID 获取 城市名
 *
 *  @param ID          城市ID
 *  @param defaultName 默认名字
 *
 *  @return 城市名 ,return defaultName when fail
 */
- (NSString *)citynameForID:(int)ID withDefault:(NSString *)defaultName;

/**
 *  根据 区号 获取 城市ID
 *
 *  @param code 区号
 *
 *  @return 城市ID, return -1 when none found.
 */
- (int)cityIdForCityCode:(int)code;
/**
 *  根据 城市ID 获取 城市
 *
 *  @param id_ 城市ID
 *
 *  @return 城市
 */
- (id)objectForId:(long long)id_;

/**
 *  条件查询
 *
 *  @param predicate 条件
 *
 *  @return 符合条件的城市列表
 */
- (NSMutableArray *)objectsWithPredicate:(NSPredicate *)predicate;

/**
 *  删除所有对象
 */
- (void)removeAllObject;

@end
