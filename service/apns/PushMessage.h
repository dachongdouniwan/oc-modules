//
//  PushMessage.h
//  consumer
//
//  Created by fallen.ink on 8/2/16.
//
//

#import "_model.h"

@interface PushMessage : _Model

@property (nonatomic, strong) NSString *notification;

@property (nonatomic, assign) int32_t type;

@property (nonatomic, assign) int64_t recordId;

@end
