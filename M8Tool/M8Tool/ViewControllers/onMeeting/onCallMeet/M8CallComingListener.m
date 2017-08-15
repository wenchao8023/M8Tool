 //
//  M8CallComingListener.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallComingListener.h"

#import "M8MeetWindow.h"
#import "M8MeetWindowSingleton.h"
#import "M8CallViewController.h"




@implementation M8CallComingListener


/**
 通话邀请通知

 @param invitation 邀请信息,
 
 custom    : curMid + title @"curMid,title"
 */
- (void)onMultiCallInvitation:(TILCallInvitation *)invitation
{
    if ([M8UserDefault getIsInMeeting])
    {
        return ;
    }
    
    NSString *sponsor = invitation.sponsorId;
    NSString *inviter = invitation.inviterId;
    
    NSArray *tipArr  = [invitation.custom componentsSeparatedByString:@","];
    
    NSMutableArray *tempMembersArr = [NSMutableArray arrayWithCapacity:0];

    TIMFriendshipManager *frdManger = [TIMFriendshipManager sharedInstance];
    [frdManger GetUsersProfile:invitation.memberArray succ:^(NSArray *friends) {
        
        for (TIMUserProfile *profile in friends)
        {
            M8MemberInfo *mInfo = [[M8MemberInfo alloc] initWithTIMUserProfile:profile];
            [tempMembersArr addObject:mInfo];
        }
        
        //配置初始参会成员
        M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
        [modelManger updateInviteMemberArray:tempMembersArr];
        
        TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
        item.uid        = [M8UserDefault getLoginId];
        item.members    = invitation.memberArray;
        item.callType   = invitation.callType;
        
        item.info = [[ShowRoomInfo alloc] init];
        item.info.title     = [tipArr lastObject];
        item.info.type      = (invitation.callType == TILCALL_TYPE_VIDEO ? @"call_video" : @"call_audio");
        item.info.roomnum   = invitation.callId;
        item.info.groupid   = [NSString stringWithFormat:@"%d", invitation.callId];
        item.info.appid     = [ILiveAppId intValue];
        item.info.host      = sponsor;
        
        M8CallViewController *callVC = [[M8CallViewController alloc] initWithItem:item isHost:[sponsor isEqualToString:[M8UserDefault getLoginId]]];
        callVC.isJoinSelf = (![sponsor isEqualToString:inviter] && [sponsor isEqualToString:[M8UserDefault getLoginId]]);
        callVC.invitation = invitation;
        callVC.curMid     = [[tipArr firstObject] intValue];
        [M8MeetWindow M8_addMeetSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
        
    } fail:^(int code, NSString *msg) {
        
        NSString *errInfo = [NSString stringWithFormat:@"errDomain: TIMSDK, errCode: %d\nerrInfo: %@", code, msg];
        [AlertHelp alertWith:nil message:errInfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
    }];
}

@end
