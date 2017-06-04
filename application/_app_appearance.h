//
//  _app_appearance.h
//  student
//
//  Created by fallen.ink on 12/04/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_building_precompile.h"

#import "UIButton+Appearance.h"
#import "UIColor+Appearance.h"

@interface _AppAppearance : NSObject

@singleton( _AppAppearance )

@prop_strong( UIColor *, themeColor )
@prop_strong( UIColor *, viewBackgroundColor )
@prop_strong( UIColor *, navigationBarBackgroundColor )
@prop_strong( UIColor *, navigationBarForegroundColor )


@prop_strong( NSString *, navigationBarBackButtonImage )

- (void)build;

@end

#define appAppearance [_AppAppearance sharedInstance]

#undef  color_theme
#define color_theme appAppearance.themeColor

#undef  color_background_view
#define color_background_view appAppearance.viewBackgroundColor

#undef  color_background_nav
#define color_background_nav appAppearance.viewBackgroundColor

#undef  color_separator_view
#define color_separator_view gray_3

#define line_gray       font_gray_1

#define background_gray color_background_view
