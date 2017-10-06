//
//  UIImage+Capture.h
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage ( Capture )

/**
 @knowledge
 
 * 模糊效果，是用截屏＋虚化实现的（1. 基于UIWindow 2. 基于 子 的UIViewController）
 
 * 还用于实现：侧滑反馈效果
 */

/**
 *  @brief  截图指定view成图片
 *
 *  @param view 一个view
 *
 *  @return 图片
 */
+ (UIImage *)captureWithView:(UIView *)view;

+ (UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *)bigImage;

/**
 *  @author Jakey
 *
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *
 *  @param aView    指定的view
 *  @param maxWidth 宽的大小 0为view默认大小
 *
 *  @return 截图
 */
+ (UIImage *)screenshotWithView:(UIView *)aView limitWidth:(CGFloat)maxWidth;

+ (UIImage *)imageFromText:(NSArray*)arrContent withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor withBgImage:(UIImage *)bgImage withBgColor:(UIColor *)bgColor;

+ (UIImage *)imageFromScrollView:(UIScrollView *)scrollView;
@end
