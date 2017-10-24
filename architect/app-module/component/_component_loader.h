//
//  _component_loader.h
//  kata
//
//  Created by fallen.ink on 22/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_foundation.h"

@interface _ComponentLoader : NSObject

@singleton( _ComponentLoader )

@prop_readonly( NSArray *, components );

- (id)component:(Class)classType;

- (void)installComponents;
- (void)uninstallComponents;

@end
