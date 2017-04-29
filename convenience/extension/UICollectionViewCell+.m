//
//  UICollectionViewCell+_.m
//  FATodos
//
//  Created by qingqing on 16/1/29.
//  Copyright © 2016年 fallen.ink. All rights reserved.
//

#import "UICollectionViewCell+.h"

@implementation UICollectionViewCell (Template)

#pragma mark - Class

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

#pragma mark - Object

- (void)setModel:(id)model {
    // do nothing.
}

#pragma mark - On UITableView

+ (void)registerOnNib:(UICollectionView *)collectionView{
    NSAssert(collectionView, @"collectionView nil");

    [collectionView registerNib:[self nib]
     forCellWithReuseIdentifier:[self identifier]];
}

+ (void)registerOnClass:(UICollectionView *)collectionView {
    NSAssert(collectionView, @"collectionView nil");
    
    [collectionView registerClass:[self class]
       forCellWithReuseIdentifier:[self identifier]];
}

@end
