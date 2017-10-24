//
//  _cursor.m
//  student
//
//  Created by fallen.ink on 18/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_cursor.h"
#import "_building_precompile.h"

// ----------------------------------
// Category source code
// ----------------------------------

@implementation NSObject ( Cursor )

// Page cursor
- (_Cursor *)pageCursor {
    _Cursor *cursor = [self getAssociatedObjectForKey:"pageCursor"];
    
    if (!cursor) {
        cursor = [[_Cursor alloc] initWithType:CursorType_Page];
        
        [self retainAssociatedObject:cursor forKey:"pageCursor"];
    }
    
    return cursor;
}

// Tag cursor
- (_Cursor *)tagCursor {
    _Cursor *cursor = [self getAssociatedObjectForKey:"tagCursor"];
    
    if (!cursor) {
        cursor = [[_Cursor alloc] initWithType:CursorType_Tag];
        
        [self retainAssociatedObject:cursor forKey:"tagCursor"];
    }
    
    return cursor;
}

@end

// ----------------------------------
// Source code
// ----------------------------------

#define CURSOR_PAGE_COUNT 10

@interface _Cursor ()

@property (nonatomic, assign) CursorType type;

@end

@implementation _Cursor

- (instancetype)initWithType:(CursorType)type {
    if (self = [super init]) {
        self.type = type;
        
        [self reset];
        
    }

    return self;
}

- (void)reset {
    self.start = 0;
    self.length = CURSOR_PAGE_COUNT;
    self.end = NO;
    
    self.tag = nil;
}

- (void)next {
    self.start += self.length;
}

- (void)evaluateEndWith:(int32_t)actualCount {
    if (actualCount < self.length) {
        self.end = YES;
    } else {
        [self next];
    }
}

@end
