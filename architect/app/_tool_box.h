//
//  _idiot.h
//  student
//
//  Created by fallen.ink on 28/09/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_foundation.h"
#import "_i_utility.h"
#import "_i_processor.h"
#import "_i_validator.h"

@protocol _ToolBox <NSObject>

//@prop_strong(id<_IApplication>, app)

//@prop_strong(id<_ICache>, cache)
//
//@prop_strong(id<_INetwork>, net)

@prop_strong(id<_IUtility>, util)

//@prop_strong(id<_IDatabase>, db)

@prop_strong(id<_IProcessor>, processor)

@prop_strong(id<_IValidator>, validator)

@end
