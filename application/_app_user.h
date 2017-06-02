//
//  _app_user.h
//  student
//
//  Created by fallen.ink on 19/05/2017.
//  Copyright © 2017 alliance. All rights reserved.
//

#import "_building_precompile.h"
#import "_archiver.h"

// 当前只支持单用户，可以扩展

@interface _AppUser : NSObject

@singleton(_AppUser)

// 用户实体

@prop_assign( int64_t, id )
@prop_strong( NSString *, token ) // 用户验证
@prop_strong( NSString *, session ) // 用户过期验证

- (void)clear;

- (void)save;

@end

#undef  user_inst
#define user_inst [_AppUser sharedInstance]