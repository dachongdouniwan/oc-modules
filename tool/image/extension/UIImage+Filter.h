//
//  UIImage+Filter.h
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageFilterPreset)
{
    ImageFilterPresetBlackAndWhite,
    ImageFilterPresetSepiaTone,
    ImageFilterPresetPixelate
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Filter)

/** Asynchronously applies 'filter' to the target image and
 returns the filtered image in the block.
 The target image remains unchanged.
 */
- (void)applyFilter:(CIFilter *)filter completion:(void (^)(UIImage *filteredImage))completion;

/// @return A UIImage from the filter.
+ (UIImage *)imageWithFilter:(CIFilter *)filter;

/// @return A filter using a common preset.
- (CIFilter *)filterWithPreset:(ImageFilterPreset)preset;

@end

NS_ASSUME_NONNULL_END
