//
//  M8CallComingListener.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallComingListener.h"

#import "M8MeetWindow.h"
#import "M8CallViewController.h"

#import "M8InviteModelManger.h"


@implementation M8CallComingListener


/**
 通话邀请通知

 @param invitation 邀请信息,
 
 callTip    : curMid + title @"curMid,title"
 成员nick数组 : custom @"nick1,nick2,nick3,..."
 */
- (void)onMultiCallInvitation:(TILCallInvitation *)invitation
{
    NSArray *tipArr = [invitation.callTip componentsSeparatedByString:@","];
    NSArray *nickArr = [invitation.custom componentsSeparatedByString:@","];
    NSArray *uidArr  = invitation.memberArray;
    
    //配置初始参会成员
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < uidArr.count; i++)
    {
        M8MemberInfo *info = [[M8MemberInfo alloc] init];
        info.uid    = uidArr[i];
        info.nick   = nickArr[i];
        [tempArr addObject:info];
    }
    
    [modelManger updateInviteMemberArray:tempArr];
    
    
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid        = [M8UserDefault getLoginId];
    item.members    = invitation.memberArray;
    item.callType   = invitation.callType;
    
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title     = [tipArr lastObject];
    item.info.type      = (invitation.callType == TILCALL_TYPE_VIDEO ? @"call_video" : @"call_audio");
    item.info.roomnum   = invitation.callId;
    item.info.groupid   = [NSString stringWithFormat:@"%d", invitation.callId];
    item.info.appid     = [ShowAppId intValue];
    item.info.host      = invitation.sponsorId;
    
    M8CallViewController *callVC = [[M8CallViewController alloc] initWithItem:item isHost:NO];
    callVC.invitation = invitation;
    callVC.curMid     = [[tipArr firstObject] intValue];
    [M8MeetWindow M8_addMeetSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];

    
    
//    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
//    item.uid        = [M8UserDefault getLoginId];
//    item.members    = invitation.memberArray;
//    item.callType   = invitation.callType;
//    
//    item.info = [[ShowRoomInfo alloc] init];
//    item.info.title     = invitation.custom;
//    item.info.type      = (invitation.callType == TILCALL_TYPE_VIDEO ? @"call_video" : @"call_audio");
//    item.info.roomnum   = invitation.callId;
//    item.info.groupid   = [NSString stringWithFormat:@"%d", invitation.callId];
//    item.info.appid     = [ShowAppId intValue];
//    item.info.host      = invitation.sponsorId;
//    
//    M8CallViewController *callVC = [[M8CallViewController alloc] initWithItem:item isHost:NO];
//    callVC.invitation = invitation;
//    callVC.curMid     = [invitation.callTip intValue];
//    [M8MeetWindow M8_addMeetSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
}

@end
