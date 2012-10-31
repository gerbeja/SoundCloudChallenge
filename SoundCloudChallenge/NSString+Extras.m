//
//  NSString+Extras.m
//  SoundCloudChallenge
//
//  Created by German Bejarano on 10/30/12.
//  Copyright (c) 2012 German Bejarano. All rights reserved.
//

#import "NSString+Extras.h"

@implementation NSString (Extras)

- (NSString *)formattedDate{
    /* Formatting the String Date into Date and then generating the Human Readable String */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss ZZZ"];
    NSDate *formattedDate = [formatter dateFromString:self];
    
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [formatter stringFromDate:formattedDate];
}

@end
