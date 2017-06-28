//
//  M8LiveInfoViewManager.m
//  M8Tool
//
//  Created by chao on 2017/6/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveInfoViewManager.h"
#import "M8MeetWindow.h"


@implementation M8LiveInfoViewManager

- (void)LiveDeviceViewActionInfo:(NSDictionary *)actionInfo {
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    NSString *infoValue = [actionInfo valueForKey:infoKey];
    
    [self managerLog:actionInfo];
    
    if ([infoValue isEqualToString:@"onRightButton2Action"]) {
        [M8MeetWindow M8_showFloatView];
    }
}


- (void)managerLog:(id)log {
    if ([self.WCDelegate respondsToSelector:@selector(LiveInfoViewManagerLog:)]) {
        [self.WCDelegate LiveInfoViewManagerLog:log];
    }
}



@end
