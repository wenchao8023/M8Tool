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

#pragma mark -- RenderModelMangerDelegate
- (void)renderModelManager:(id)renderModelManger
            bgViewIdentify:(NSString *)bgViewIdentify
           renderViewArray:(NSArray *)renderViewArray
{
    if (self.isInFloatView)
    {
        return ;
    }
    
    self.membersArray = renderViewArray;
    
    [self.renderView updateWithRenderModelManager:renderModelManger
                                   bgViewIdentify:bgViewIdentify
                                  renderViewArray:renderViewArray
     ];
}

- (void)renderModelManger:(id)renderModelManger inviteMember:(NSString *)inviteMemberId
{
    [self inviteMember:inviteMemberId];
}

#pragma mark -- 音视频事件回调
- (void)onMemberAudioOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members)
    {
        NSString *identify = member.identifier;
        [self.renderModelManger onMemberAudioOn:isOn WithID:identify];
    }
}

- (void)onMemberCameraVideoOn:(BOOL)isOn members:(NSArray *)members
{
    for (TILCallMember *member in members)
    {
        NSString *identify = member.identifier;
        [self.renderModelManger onMemberCameraVideoOn:isOn WithID:identify];
        
        if (isOn)
        {
            [self.call addRenderFor:identify atFrame:CGRectZero];
        }
        else
        {
            [self.call removeRenderFor:identify];
        }
        
        //判断浮动视图的时候 发起人的状态 (用于接收端)
        if (self.isInFloatView &&
            [identify isEqualToString:self.liveItem.info.host])
        {
            [self.floatView onCallVideoListener:isOn];
        }
    }
}




#pragma mark -- 通知回调
- (void)onRecvNotification:(TILCallNotification *)notify
{
    NSInteger notifId = notify.notifId;
    NSString *sender = notify.sender;
    NSString *target = [notify.targets componentsJoinedByString:@";"];
    
    
    switch (notifId)
    {
        case TILCALL_NOTIF_INVITE:
        {
            [self addMember:sender withTip:[NSString stringWithFormat:@"邀请%@通话", target]];
        }
            
            break;
        case TILCALL_NOTIF_ACCEPTED:
        {
            /*
             * sender 不会是发起方
             * sender 不会是 App登录用户 的接收方
             */
            [self onNetReportCallMem:sender statu:1];
            [self addMember:sender withTip:[NSString stringWithFormat:@"接受了%@的邀请", target]];
            // 只要有人接受了邀请，就应该是结束通话
            if (self.isHost)
            {
                self.shouldHangup = YES;
            }
            
            [self.renderModelManger memberReceiveWithID:sender];
        }
            break;
        case TILCALL_NOTIF_CANCEL:  //这里应该判断是否是发起人取消了通话
        {
            [self addMember:sender withTip:[NSString stringWithFormat:@"取消了对%@的邀请", target]];
            if([notify.targets containsObject:self.liveItem.uid])   //判断自己是不是取消对象
            {
                if ([sender isEqualToString:self.liveItem.info.host])
                {
                    [self addMember:nil withTip:@"通话被取消"];
                    [self selfDismiss];
                }
            }
        }
            break;
        case TILCALL_NOTIF_TIMEOUT:
        {
            [self.renderModelManger memberTimeoutWithID:sender];
            if([sender isEqualToString:self.liveItem.uid])
            {
                [self addMember:sender withTip:@"呼叫超时"];
                [self selfDismiss];
            }
            else
            {
                [self onNetReportCallMem:sender statu:0];
                [self addMember:sender withTip:@"手机可能不在身边"];
            }
        }
            break;
        case TILCALL_NOTIF_REFUSE:
        {
            [self onNetReportCallMem:sender statu:2];
            [self addMember:sender withTip:@"拒绝了邀请"];
            [self.renderModelManger memberRejectInviteWithID:sender];
        }
            break;
        case TILCALL_NOTIF_HANGUP:
        {
            [self addMember:sender withTip:@"挂断"];
            [self.renderModelManger memberHangupWithID:sender];
            
            if ([sender isEqualToString:self.liveItem.uid])
            {
                [self selfDismiss];
            }
        }
            break;
        case TILCALL_NOTIF_LINEBUSY:
        {
            [self addMember:sender withTip:@"用户忙"];
            if (self.isHost)
            {
                self.shouldHangup = YES;
            }
            [self onNetReportCallMem:sender statu:0];
            [self.renderModelManger memberLineBusyWithID:sender];
            
        }
            break;
        case TILCALL_NOTIF_HEARTBEAT:
        {
//            [self addTextToView:[NSString stringWithFormat:@"%@发来心跳",sender]];
        }
            break;
        case TILCALL_NOTIF_DISCONNECT:
        {
            [self addMember:sender withTip:@"失去连接"];
            if([sender isEqualToString:self.liveItem.uid])
            {
                [self selfDismiss];
            }
            else
            {
                [self.renderModelManger memberDisconnetWithID:sender];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 接到邀请成员加入会议的通知
- (void)onReceiveInviteMembers
{
    [self hiddeFloatView];
    
    M8InviteModelManger *inviteModelManger = [M8InviteModelManger shareInstance];
    
    //保存选中的成员
    NSMutableArray *nickArr = [NSMutableArray arrayWithCapacity:0];
    for (M8MemberInfo *info in inviteModelManger.selectMemberArray)
    {
        [nickArr addObject:info.uid];
    }
    
    [self.renderModelManger onInviteMembers];   //这里去加载数据
    
    // 发起邀请 + 配置成员信息（这一步由 ModelManger 完成）
    [self inviteMembers:nickArr];
}

@end
