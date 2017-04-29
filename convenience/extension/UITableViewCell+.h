//
//  UITableViewCell+.h
//  XFAnimations
//
//  Created by fallen.ink on 11/24/15.
//  Copyright © 2015 fallen.ink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Template)

+ (NSString *)identifier;
+ (UINib *)nib;

+ (CGFloat)cellHeight;
- (CGFloat)cellHeight;
+ (CGFloat)cellHeightWithModel:(id)model;

- (void)setModel:(id)obj;

#pragma mark - On UITableView

+ (void)registerOnNib:(UITableView *)tableView;
+ (void)registerOnClass:(UITableView *)tableView;

@end
