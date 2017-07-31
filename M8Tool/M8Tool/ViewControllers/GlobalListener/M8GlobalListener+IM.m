//
//  M8GlobalListener+IM.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalListener+IM.h"

#import "M8GlobalWindow.h"
#import "M8LoginWebService.h"

@implementation M8GlobalListener (IM)

#pragma mark - -- TIMUserStatusListener 用户在线状态通知
/**
 *  踢下线通知
 */
- (void)onForceOffline
{
    WCLog(@"踢下线通知");
    [M8GlobalWindow M8_addAlertInfo:@"你的账号在其他地方登录。如果本人操作，则密码可能已泄露。建议修改密码或联系客服人员。" alertType:GlobalAlertType_forceOffline];
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err
{
    WCLog(@"断线重连失败");
}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired
{
    WCLog(@"用户登录的userSig过期（用户需要重新获取userSig后登录）");
    
    [[AppDelegate sharedAppDelegate] enterLoginUI];
}



#pragma mark - -- TIMConnListener 连接通知回调
/**
 *  网络连接成功
 */
- (void)onConnSucc
{
    WCLog(@"网络连接成功");
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err
{
    WCLog(@"网络连接失败");
}

/**
 *  网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线）
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err
{
    WCLog(@"网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线）");
}


/**
 *  连接中
 */
- (void)onConnecting
{
    WCLog(@"连接中");
}



#pragma mark - -- TIMMessageListener 消息回调
/**
 *  新消息回调通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray*) msgs
{
    for (TIMMessage * msg in msgs)
    {
        for (int i = 0; i < [msg elemCount]; i++)
        {
            TIMElem * elem = [msg getElem:i];
            if ([elem isKindOfClass:[TIMSNSSystemElem class]])
            {
                TIMSNSSystemElem * system_elem = (TIMSNSSystemElem * )elem;
                switch ([system_elem type])
                {
                    case TIM_SNS_SYSTEM_ADD_FRIEND:
                    {
                        NSMutableArray *identifyArr = [NSMutableArray arrayWithCapacity:0];
                        for (TIMSNSChangeInfo * info in [system_elem users])
                        {
                            NSLog(@"user %@ become friends", [info identifier]);
                            [M8UserDefault setNewFriendNotify:YES];
                            [identifyArr addObject:[info identifier]];
                            [WCNotificationCenter postNotificationName:kNewFriendStatu_Notification object:nil];
                        }
                        
                        [M8UserDefault setNewFriendIdentify:identifyArr];
                    }
                        
                        break;
                    case TIM_SNS_SYSTEM_DEL_FRIEND:
                        for (TIMSNSChangeInfo * info in [system_elem users])
                        {
                            NSLog(@"user %@ delete friends", [info identifier]);
                        }
                        break;
                    case TIM_SNS_SYSTEM_ADD_FRIEND_REQ:
                        for (TIMSNSChangeInfo * info in [system_elem users])
                        {
                            NSLog(@"user %@ request friends: reason=%@", [info identifier], [info wording]);
                        }
                        break;
                    default:
                        NSLog(@"ignore type");
                        break;
                }
            }
        }
    }
}


@end
