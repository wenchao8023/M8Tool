//
//  MMeetWindow.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MMeetWindow.h"
#import "MMeetWindowSingleton.h"

@implementation MMeetWindow

+ (void)M_addMeetSource:(id)source WindowOnTarget:(id)target
{
    [[MMeetWindowSingleton shareInstance] addMeetSource:source WindowOnTarget:target];
}

+ (void)M_showFloatView
{
    [[MMeetWindowSingleton shareInstance] showFloatView];
}

+ (void)M_hiddeFloatView
{
    [[MMeetWindowSingleton shareInstance] hiddeFloatView];
}

@end
