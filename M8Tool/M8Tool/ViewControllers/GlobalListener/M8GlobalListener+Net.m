//
//  M8GlobalListener+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalListener+Net.h"


@implementation M8GlobalListener (Net)

- (void)startnetMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                [self onAFNetworkReachabilityStatusUnknown];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                [self onAFNetworkReachabilityStatusNotReachable];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [self onAFNetworkReachabilityStatusReachableViaWWAN];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [self onAFNetworkReachabilityStatusReachableViaWiFi];
            }
        }
    }];
}

//未知网络
- (void)onAFNetworkReachabilityStatusUnknown
{
    NSLog(@"未知网络");
    [AppDelegate sharedAppDelegate].netEnable = NO;
    if ([M8UserDefault getAppIsLaunching])
    {
        [WCNotificationCenter postNotificationName:kAppLaunchingNet_Notification object:nil userInfo:nil];
    }
    
    [WCNotificationCenter postNotificationName:kAppNetStatus_Notification object:@(AFNetworkReachabilityStatusUnknown)];
}

//无法联网
- (void)onAFNetworkReachabilityStatusNotReachable
{
    NSLog(@"无法联网");
    [AppDelegate sharedAppDelegate].netEnable = NO;
    if ([M8UserDefault getAppIsLaunching])
    {
        [WCNotificationCenter postNotificationName:kAppLaunchingNet_Notification object:nil userInfo:nil];
    }
    [WCNotificationCenter postNotificationName:kAppNetStatus_Notification object:@(AFNetworkReachabilityStatusNotReachable)];
}

//手机自带网络
- (void)onAFNetworkReachabilityStatusReachableViaWWAN
{
    NSLog(@"当前使用的是2g/3g/4g网络");
    [AppDelegate sharedAppDelegate].netEnable = YES;
    [WCNotificationCenter postNotificationName:kAppNetStatus_Notification object:@(AFNetworkReachabilityStatusReachableViaWWAN)];
}

//WIFI
- (void)onAFNetworkReachabilityStatusReachableViaWiFi
{
    NSLog(@"当前在WIFI网络下");
    [AppDelegate sharedAppDelegate].netEnable = YES;
    [WCNotificationCenter postNotificationName:kAppNetStatus_Notification object:@(AFNetworkReachabilityStatusReachableViaWiFi)];
}
@end
