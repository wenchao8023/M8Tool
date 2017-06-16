//
//  M8MeetWindow.m
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetWindow.h"

#import "M8MeetWindowSingleton.h"


@implementation M8MeetWindow

+ (void)M8_addSource:(nonnull id)source WindowOnTarget:(nonnull id)target {
    [[M8MeetWindowSingleton getInstance] addSource:source WindowOnTarget:target];
}
+ (void)M8_showFloatView {
    [[M8MeetWindowSingleton getInstance] showFloatView];
}
+ (void)M8_hiddeFloatView {
    [[M8MeetWindowSingleton getInstance] hiddeFloatView];
}

@end
