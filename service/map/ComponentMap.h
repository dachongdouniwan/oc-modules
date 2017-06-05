//
//  ComponentMap.h
//  component
//
//  Created by fallen.ink on 3/16/16.
//  Copyright © 2016 OpenTeam. All rights reserved.
//

#import "_building_precompile.h"
#import "ComponentMapConfig.h"

@class ComponentMapConfig;

@interface ComponentMap : NSObject

@singleton( ComponentMap )

@prop_instance( ComponentMapConfig, config)

- (void)initGDAPIKey;

@end
