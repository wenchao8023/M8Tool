//
//  AppDelegate+PushKit.m
//  M8Tool
//
//  Created by chao on 2017/8/21.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate+PushKit.h"

@implementation AppDelegate (PushKit)


- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type
{
    
}


- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{
    if([credentials.token length] == 0) {
        NSLog(@"voip token NULL");
        return;
    }
    //应用启动获取token，并上传服务器
    self.deviceTokenStr = [[[[credentials.token description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type
{
    
}

@end
