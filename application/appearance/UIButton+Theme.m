//
//  UIButton+Theme.m
// fallen.ink
//
//  Created by 李杰 on 4/20/15.
//
//

#import "UIButton+Theme.h"
#import "UIColor+theme.h"
#import "UIView+Extension.h"

#pragma mark -

@implementation UIButton (Theme)

- (void)thematized {
    [self colorlumpStyled:[UIColor themeColor]];
    
    [self circularCorner];
}

- (void)liningThematized:(UIColor *)color {
    [self liningStyled:color];
    
    [self circularCorner];
}

- (void)liningThematizedWithTextColor:(UIColor *)color borderColor:(UIColor *)bordercolor {
    [self liningStyledWithTitleColor:color borderColor:bordercolor];
    
    [self circularCorner];
}

- (void)colorlumpThematized:(UIColor *)color {
    [self colorlumpStyled:color];
    
    [self circularCorner];
}

- (void)thematizedWithBackgroundColor:(UIColor*)backgroundColor {
    [self colorlumpStyled:backgroundColor];
    
    [self circularCorner];
}

@end
