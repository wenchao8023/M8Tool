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


@implementation M8CallComingListener


/**
 通话邀请通知

 @param invitation 邀请信息, title 由发起的时候配置custom
 */
- (void)onMultiCallInvitation:(TILCallInvitation *)invitation
{    
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid = [[ILiveLoginManager getInstance] getLoginId];
    item.members = invitation.memberArray;
    item.callType = invitation.callType;
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title = invitation.custom;
    item.info.type = (invitation.callType == TILCALL_TYPE_VIDEO ? @"call_video" : @"call_audio");
    item.info.roomnum = invitation.callId;
    item.info.groupid = [NSString stringWithFormat:@"%d", invitation.callId];
    item.info.appid = [ShowAppId intValue];
    item.info.host = invitation.sponsorId;
    
    M8CallViewController *callVC = [[M8CallViewController alloc] initWithItem:item isHost:NO];
    callVC.invitation = invitation;
    callVC.curMid     = [invitation.callTip intValue];
    [M8MeetWindow M8_addMeetSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
}

@end
