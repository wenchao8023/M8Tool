//
//  M8CallViewController+CallListener.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController+CallListener.h"

#import "M8CallViewController+Net.h"


@implementation M8CallViewController (CallListener)

#pragma mark -- RenderModelManagerDelegate
- (void)renderModelManager:(id)modelManager currentIdentifier:(NSString *)curId membersArray:(NSArray *)membersArray
{
    [self.renderView updateWithModelManager:modelManager currentIdentifier:curId membersArray:membersArray];
}

#pragma mark -- 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members)
    {
        NSString *identify = member.identifier;
        [self.modelManager memberNotifyWithID:identify];
        [self.modelManager onMemberAudioOn:isOn WithID:identify];
    }
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members)
    {
        NSString *identify = member.identifier;
        [self.modelManager memberNotifyWithID:identify];
        [self.modelManager onMemberCameraVideoOn:isOn WithID:identify];
        
        if (isOn)
        {
            [self.call addRenderFor:identify atFrame:CGRectZero];
        }
        else
        {
            [self.call removeRenderFor:identify];
        }
    }
}




#pragma mark -- 通知回调
- (void)onRecvNotification:(TILCallNotification *)notify
{
    NSInteger notifId = notify.notifId;
    NSString *sender = notify.sender;
    NSString *target = [notify.targets componentsJoinedByString:@";"];
    
    [self.modelManager memberNotifyWithID:sender];
    
    switch (notifId) {
        case TILCALL_NOTIF_INVITE:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@邀请%@通话",sender,target]];
        }
            
            break;
        case TILCALL_NOTIF_ACCEPTED:
        {
            /*
             * sender 不会是发起方
             * sender 不会是 App登录用户 的接收方
             */
            [self onNetReportCallMem:sender statu:1];
            [self addTextToView:[NSString stringWithFormat:@"%@接受了%@的邀请",sender,target]];
            // 只要有人接受了邀请，就应该是结束通话
            self.shouldHangup = YES;
            [self.modelManager memberReceiveWithID:sender];
        }
            break;
        case TILCALL_NOTIF_CANCEL:  //这里应该判断是否是发起人取消了通话
        {
            [self addTextToView:[NSString stringWithFormat:@"%@取消了对%@的邀请",sender,target]];
            if([notify.targets containsObject:self.liveItem.uid])
            {
                [self addTextToView:@"通话被取消"];
                [self selfDismiss];
            }
        }
            break;
        case TILCALL_NOTIF_TIMEOUT:
        {
            if([sender isEqualToString:self.liveItem.uid])
            {
                [self addTextToView:[NSString stringWithFormat:@"%@呼叫超时",sender]];
                [self selfDismiss];
            }
            else
            {
                [self onNetReportCallMem:sender statu:0];
                [self addTextToView:[NSString stringWithFormat:@"%@手机可能不在身边",sender]];
                [self.modelManager memberTimeoutWithID:sender];
            }
        }
            break;
        case TILCALL_NOTIF_REFUSE:
        {
            [self onNetReportCallMem:sender statu:2];
            [self addTextToView:[NSString stringWithFormat:@"%@拒绝了%@的邀请",sender,target]];
            [self.modelManager memberRejectInviteWithID:sender];
        }
            break;
        case TILCALL_NOTIF_HANGUP:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@挂断了%@邀请的通话",sender,target]];
            [self.modelManager memberHangupWithID:sender];
        }
            break;
        case TILCALL_NOTIF_LINEBUSY:
        {
            [self onNetReportCallMem:sender statu:0];
            [self addTextToView:[NSString stringWithFormat:@"%@占线，无法接受%@的邀请",sender,target]];
            [self.modelManager memberLineBusyWithID:sender];
        }
            break;
        case TILCALL_NOTIF_HEARTBEAT:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@发来心跳",sender]];
        }
            break;
        case TILCALL_NOTIF_DISCONNECT:
        {
            [self addTextToView:[NSString stringWithFormat:@"%@失去连接",sender]];
            if([sender isEqualToString:self.liveItem.uid])
            {
                [self selfDismiss];
            }
            else {
                [self.modelManager memberDisconnetWithID:sender];
            }
        }
            break;
        default:
            break;
    }
}

@end
