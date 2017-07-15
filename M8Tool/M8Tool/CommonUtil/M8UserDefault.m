//
//  M8UserDefault.m
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8UserDefault.h"

@implementation M8UserDefault
 + (NSString *)getLoginId
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginIdentifier] stringValue];
}


#pragma mark - kIsInMeeting
+ (BOOL)getIsInMeeting
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kIsInMeeting] boolValue];
}

+ (void)setMeetingStatu:(BOOL)isInMeeting
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setBool:isInMeeting forKey:kIsInMeeting];
    [userD synchronize];
}

@end
