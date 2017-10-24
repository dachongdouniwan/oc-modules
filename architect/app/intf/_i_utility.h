//
//  IUtility.h
//  student
//
//  Created by fallen.ink on 27/09/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_foundation.h"
#import "_i_utility_formatter.h"
#import "_i_utility_date.h"
#import "_i_utility_image.h"

@protocol _IUtility <NSObject>

@prop_strong(id<_IUtilityFormatter>, format)


@end
