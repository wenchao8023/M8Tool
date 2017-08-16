//
//  LoadTIMManager.m
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "LoadTIMManager.h"

@implementation LoadTIMManager
+ (void)load {
    
    kDISPATCH_ONCE_BLOCK(^{
        TIMManager *manager = [[ILiveSDK getInstance] getTIMManager];
        NSNumber *evn = [[NSUserDefaults standardUserDefaults] objectForKey:kEnvParam];
        [manager setEnv:[evn intValue]];
        NSNumber *logLevel = [[NSUserDefaults standardUserDefaults] objectForKey:kLogLevel];
        [manager initLogSettings:YES logPath:[manager getLogPath]];
        [manager setLogLevel:(TIMLogLevel)[logLevel integerValue]];
    });
}

@end
