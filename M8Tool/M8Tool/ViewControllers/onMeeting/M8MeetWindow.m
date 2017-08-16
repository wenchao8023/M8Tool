//
//  M8MeetWindow.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetWindow.h"
#import "M8MeetWindowSingleton.h"

@implementation M8MeetWindow

+ (void)M8_addMeetSource:(id)source WindowOnTarget:(id)target
{
    [[M8MeetWindowSingleton shareInstance] addMeetSource:source WindowOnTarget:target];
}

+ (void)M8_addMeetSource:(id)source WindowOnTarget:(id)target succHandle:(M8VoidBlock)succ
{
    [[M8MeetWindowSingleton shareInstance] addMeetSource:source WindowOnTarget:target succHandle:succ];
}

+ (void)M8_showFloatView
{
    [[M8MeetWindowSingleton shareInstance] showFloatView];
}

+ (void)M8_hiddeFloatView
{
    [[M8MeetWindowSingleton shareInstance] hiddeFloatView];
}


@end
