//
//  Model.h
//  component
//
//  Created by fallen.ink on 5/26/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

/**
 *  视图模型、可持久话model层模型、ViewModel
 */

#import "Mantle.h"
#import "MTLModel+FormatHelper.h"

#pragma mark -

#undef  impl_list_JSONTransformer
#define impl_list_JSONTransformer( _variablename_, _classname_ ) \
    + (NSValueTransformer *)_variablename_##JSONTransformer { \
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {\
            NSArray *jsonArray = value;\
            NSMutableArray *objs = [NSMutableArray array];\
            \
            [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {\
                _classname_ *object = [MTLJSONAdapter modelOfClass:[_classname_ class] fromJSONDictionary:obj error:nil];\
                [objs addObject:object];\
            }];\
            \
            return objs;\
        }];\
    }

#undef  impl_embed_class_JSONTransformer
#define impl_embed_class_JSONTransformer( _variablename_, _classname_ ) \
    + (NSValueTransformer *)_variablename_##JSONTransformer {\
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:_classname_.class];\
    }

#undef  impl_date_JSONTransformer
#define impl_date_JSONTransformer( _variablename_ ) \
    + (NSValueTransformer *)_variablename_##JSONTransformer {\
        return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {\
            return [self.dateFormatter dateFromString:dateString];\
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {\
            return [self.dateFormatter stringFromDate:date];\
        }];\
    }

#pragma mark -

@interface _Model : MTLModel <MTLJSONSerializing>

#pragma mark - Property key mapper

/**
 *  MTLJSONSerializing 协议
 *
 *  @return 默认为，子类哪一级的所有属性键值（键==值）
 
 *  可以被子类覆盖
 
 *  @注意：除非实例化该方法，不然无法做到，当property为nil（且属性为对象类型，而不是基本类型的值类型），实现 property key 可选。
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey;

/**
 *  对实例 忽略 指定的key
 *
 *  @param string ...
 */
- (void)ignoreKeyPaths:(NSObject *)string, ... NS_REQUIRES_NIL_TERMINATION;

@end
