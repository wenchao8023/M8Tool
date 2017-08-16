//
//  M8CallRenderModelManger+CallStatus.m
//  M8Tool
//
//  Created by 郭文超 on 2017/8/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderModelManger+CallStatus.h"
#import "M8CallRenderModel.h"

@implementation M8CallRenderModelManger (CallStatus)

#pragma mark - onRecvNotification
#pragma mark -- onLineBusy
- (void)memberLineBusyWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_linebusy;
    [self updateMember:model];
}


#pragma mark -- onReject
- (void)memberRejectInviteWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_reject;
    [self updateMember:model];
}


#pragma mark -- onTimeout
- (void)memberTimeoutWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_timeout;
    [self updateMember:model];
}


#pragma mark -- onWaiting (private)
- (void)memberWaitingWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_none;
    [self updateMember:model];
}



#pragma mark -- onReceive
- (void)memberReceiveWithID:(NSString *)identify
{
    //只要是为接受状态的肯定是在房间，且显示在视图上
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_receive;
    model.isInRoom = YES;
    model.isRemoved = NO;
    [self updateMember:model];
}


#pragma mark -- onDisconnet
- (void)memberDisconnetWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_disconnect;
    [self updateMember:model];
}


#pragma mark -- onHangup
- (void)memberHangupWithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.meetMemberStatus = MeetMemberStatus_hangup;
    [self updateMember:model];
}



#pragma mark - onCallMemberEventListener
- (void)onMemberAudioOn:(BOOL)isOn WithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.isMicOn = isOn;
    [self updateMember:model];
    
    [self memberReceiveWithID:identify];
}

- (void)onMemberCameraVideoOn:(BOOL)isOn WithID:(NSString *)identify
{
    M8CallRenderModel *model = [self getMemberWithID:identify];
    model.isCameraOn = isOn;
    [self updateMember:model];
    
    [self memberReceiveWithID:identify];
}



@end
