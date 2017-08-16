//
//  M8GlobalListener.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalListener.h"

@implementation M8GlobalListener

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kNewFriendStatu_Notification object:nil];
    [WCNotificationCenter removeObserver:self name:kAppLaunchingNet_Notification object:nil];
    [WCNotificationCenter removeObserver:self name:kAppNetStatus_Notification object:nil];
}


@end
