//
//  UIImage+Filter.m
//  component
//
//  Created by fallen.ink on 4/13/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "UIImage+Filter.h"

@implementation UIImage (Filter)

- (void)applyFilter:(CIFilter *)filter completion:(void (^)(UIImage *filteredImage))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIContext *context   = [CIContext contextWithOptions:nil];
        CIImage *outputImage = filter.outputImage;
        CGImageRef cgimg     = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg      = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(newImg);
        });
    });
    
}

+ (UIImage *)imageWithFilter:(CIFilter *)filter {
    CIContext *context   = [CIContext contextWithOptions:nil];
    CIImage *outputImage = filter.outputImage;
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg      = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return newImg;
}

- (CIFilter *)filterWithPreset:(ImageFilterPreset)preset {
    CIImage *image = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = nil;
    
    switch (preset) {
        case ImageFilterPresetBlackAndWhite: {
            filter = [CIFilter filterWithName:@"CIColorControls"
                                keysAndValues:kCIInputImageKey, image,
                      @"inputBrightness", @0.0,
                      @"inputContrast", @1.1,
                      @"inputSaturation", @0.0, nil];
            break;
        }
        case ImageFilterPresetSepiaTone: {
            filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, image, nil];
            break;
        }
        case ImageFilterPresetPixelate: {
            CIFilter *posterize = [CIFilter filterWithName:@"CIColorPosterize"];
            [posterize setDefaults];
            [posterize setValue:@64 forKey:@"inputLevels"];
            [posterize setValue:image forKey:@"inputImage"];
            
            filter = [CIFilter filterWithName:@"CIPixellate"];
            [filter setDefaults];
            
            [filter setValue:@64 forKey:@"inputScale"];
            [filter setValue:[posterize valueForKey:@"outputImage"] forKey:@"inputImage"];
            break;
        }
    }
    
    return filter;
}

@end
