//
//  _property_key_mapper.h
//  hairdresser
//
//  Created by fallen.ink on 7/14/16.
//
//

#import "_greats.h"

/**
 *  管理 _Model 的 KeyPaths
 
 *  @注意 移除的keyPath是针对对象的，下一次该类型对象实例化，会刷新 propertyKey 字典
 
 *  @注意 当前实现方式，不支持同一类型多个实例的批量操作！！！！！！！！！！！！！！！
 */
@interface _PropertyKeyMapper : NSObject

@singleton( _PropertyKeyMapper )

/**
 *  添加 aClass 的 propertyKey 字典，单纯刷新
 *
 *  @param aClass ...
 */
- (void)addClass:(Class)aClass;

/**
 *  是否包含 aClass 对应的 propertyKey 字典
 *
 *  @param aClass ...
 *
 *  @return YES
 */
- (BOOL)containsClass:(Class)aClass;

/**
 *  移除 aClass 对应的 ，指定的 propertyKey
 *
 *  @param keyPath ...
 *  @param aClass ...
 */
- (BOOL)removeKeyPath:(NSString *)keyPath forClass:(Class)aClass;

/**
 *  获取
 *
 *  @param aClass ...
 *
 *  @return ...
 */
- (NSDictionary *)propertyKeysForClass:(Class)aClass;

@end
