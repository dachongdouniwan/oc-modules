//
//  _application.m
//  kata
//
//  Created by fallen.ink on 22/02/2017.
//  Copyright © 2017 fallenink. All rights reserved.
//

#import "_application.h"

@implementation _Application

@def_notification( PushEnabled )
@def_notification( PushError )

@def_notification( LocalNotification )
@def_notification( RemoteNotification )

@def_notification( EnterBackground );
@def_notification( EnterForeground );

@def_notification( Ready )

@def_prop_strong( UIWindow *,			window );
@def_prop_strong( NSString *,			pushToken );
@def_prop_strong( NSError *,			pushError );
@def_prop_strong( NSString *,			sourceUrl );
@def_prop_strong( NSString *,			sourceBundleId );

@def_prop_dynamic( BOOL,				active );
@def_prop_dynamic( BOOL,				inactive );
@def_prop_dynamic( BOOL,				background );


@end
