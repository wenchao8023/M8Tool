//
//  M8LiveInfoView+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveInfoView+UI.h"

#import "M8MeetWindow.h"



@implementation M8LiveInfoView (UI)


#pragma mark - delegates
#pragma mark -- LiveDeviceViewDelegate
- (void)LiveDeviceViewActionInfo:(NSDictionary *)actionInfo
{
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    NSString *infoValue = [actionInfo valueForKey:infoKey];
    
    [self addTextToView:actionInfo];
    if ([infoValue isEqualToString:@"onRightButton2Action"])
    {
        [M8MeetWindow M8_showFloatView];
    }
}
@end
