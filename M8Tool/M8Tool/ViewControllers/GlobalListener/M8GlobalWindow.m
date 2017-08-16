//
//  M8GlobalWindow.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalWindow.h"

#import "M8GlobalWindowSingle.h"

@implementation M8GlobalWindow

+ (void)M8_addAlertInfo:(NSString *)alertInfo alertType:(GlobalAlertType)alertType
{
    [[M8GlobalWindowSingle shareInstance] addAlertInfo:alertInfo alertType:alertType];
}

@end
