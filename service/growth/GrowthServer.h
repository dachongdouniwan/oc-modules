//
//  GrowthServer.h
//  consumer
//
//  Created by 张衡的mini on 16/12/26.
//
//

#import <Foundation/Foundation.h>
#import "GrowthApi.h"

@interface GrowthServer : NSObject

- (void)uploadDocumentWithmyRequestData:(NSData *)myRequestData documentName:(NSString *)documentName successBlock:(Block)successHandler;

@end
