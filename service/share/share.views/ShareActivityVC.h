//
//  ShareActivityVC.h
//  component
//
//  Created by  on 15/12/2.
//  Copyright © 2015年 OpenTeam. All rights reserved.
//

#import "_greats.h"
#import "BaseViewController.h"
#import "ShareParamBuilder.h"

#pragma mark -
 
@class ShareActivityVC;

@interface ShareActivityVC : BaseViewController

@property (nonatomic, strong) NSString *eventCode;

@singleton( ShareActivityVC )

/**
 *  用ShareParamBuilder初始化
 */
- (void)shareWithWithParamBuilder:(ShareParamBuilder *)paramBuilder
                   shareViewTitle:(NSString *)title;
- (void)dismissSharePopup;

/**
 *  1. 动画显示，没有 mask 颜色
 *  2. 无title
 */
- (void)shareAnimatedWithWithParamBuilder:(ShareParamBuilder *)paramBuilder;

/**
 *  ...
 *
 *  @param paramBuilder ...
 *  @param validRect    默认屏幕大小
 */
//- (void)shareAnimatedWithWithParamBuilder:(ShareParamBuilder *)paramBuilder validRect:(CGRect)validRect;

/**
 *  消失
 */
- (void)dismissSharePopupAnimated;

@end
