//
//  MTLModel+FormatHelper.m
//  hairdresser
//
//  Created by fallen on 16/6/2.
//
//

#import "MTLModel+FormatHelper.h"

@implementation MTLModel (FormatHelper)

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


@end
