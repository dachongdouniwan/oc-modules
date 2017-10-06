//
//  _model.m
//  hairdresser
//
//  Created by fallen.ink on 6/4/16.
//
//

#import "_model.h"
#import "_pragma_push.h"
#import "_property_key_mapper.h"
#import "MTLValueTransformer+Extension.h"

@implementation _Model

- (instancetype)init {
    if (self = [super init]) {
        [[_PropertyKeyMapper sharedInstance] addClass:self.class];
    }
    
    return self;
}

#pragma mark - Property key mapper

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[_PropertyKeyMapper sharedInstance] propertyKeysForClass:self];
}

- (void)ignoreKeyPaths:(NSObject *)string, ... {
    va_list args;
    va_start(args, string);
    if (string) {
        // remove the first one
        [[_PropertyKeyMapper sharedInstance] removeKeyPath:(NSString *)string forClass:self.class];
        
        NSString *aString;
        while ((aString = va_arg(args, NSString *))) {
            // get all params in order
            [[_PropertyKeyMapper sharedInstance] removeKeyPath:aString forClass:self.class];
        }
    }
    va_end(args);
}

#pragma mark - Value setter

- (void)setNilValueForKey:(NSString *)key {

}

@end

#import "_pragma_pop.h"