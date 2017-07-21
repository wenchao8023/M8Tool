//
//  LoadShareSDK.m
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "LoadShareSDK.h"

@implementation LoadShareSDK

+ (void)load {
    kDISPATCH_ONCE_BLOCK(^{
#warning 这里需要注册并使用自己的Appkey
        //注册ShareSDK
        [ShareSDK registerApp:@"1ba4e87f44fec" activePlatforms:@[@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType){
            switch (platformType)
            {
                case SSDKPlatformTypeWechat:
                    [ShareSDKConnector connectWeChat:[WXApi class]];
                    break;
                default:
                    break;
            }
        }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo){
            switch (platformType)
            {
                case SSDKPlatformTypeWechat:
                    [appInfo SSDKSetupWeChatByAppId:@"wx588cac36c5d302f2" appSecret:@"f1c9fed7bd2745050bc05991d4b812e1"];
                    break;
                default:
                    break;
            }
        }];
    });
}

@end
