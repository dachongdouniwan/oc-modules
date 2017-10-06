//
//  _property_key_mapper.m
//  hairdresser
//
//  Created by fallen.ink on 7/14/16.
//
//

#import "_property_key_mapper.h"
#import "_vendor_mantle.h"

@interface _PropertyKeyMapper ()

@property (nonatomic, strong) NSMutableDictionary *pool;

@end

@implementation _PropertyKeyMapper

@def_singleton( _PropertyKeyMapper )

- (instancetype)init {
    if (self = [super init]) {
        self.pool = [NSMutableDictionary new];
    }
    
    return self;
}

#pragma mark -

- (void)addClass:(Class)aClass {
    NSSet *propertyKeys = [NSSet setWithArray:[aClass propertyKeys]];
    
    NSMutableDictionary *propertyKeyMapper = [NSMutableDictionary new];
    for (NSString *keys in propertyKeys) {
        [propertyKeyMapper setObject:[keys copy] forKey:[keys copy]];
    }
    
    [self.pool setObject:propertyKeyMapper forKey:classnameof_Class(aClass)];
}

- (BOOL)containsClass:(Class)aClass {
    return [self.pool.allKeys containsString:classnameof_Class(aClass)];
}

- (BOOL)removeKeyPath:(NSString *)keyPath forClass:(Class)aClass {
    if ([self containsClass:aClass]) {
        
        NSMutableDictionary *propertyKeyMapper = [self.pool objectForKey:classnameof_Class(aClass)];
        
        if ([propertyKeyMapper.allKeys containsString:keyPath]) {
            // Remove key path
            [propertyKeyMapper removeObjectForKey:keyPath];
            
            return YES;
        }
        
        return NO;
    }
    
    return NO;
}

- (NSDictionary *)propertyKeysForClass:(Class)aClass {
    NSDictionary *returns = nil;
    
    if (![self containsClass:aClass]) {
        [self addClass:aClass];
    }
    
    returns = [self.pool objectForKey:classnameof_Class(aClass)];

    return [returns copy];
}

@end
