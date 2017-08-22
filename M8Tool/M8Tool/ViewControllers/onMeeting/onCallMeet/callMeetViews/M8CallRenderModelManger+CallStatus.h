//
//  M8CallRenderModelManger+CallStatus.h
//  M8Tool
//
//  Created by 郭文超 on 2017/8/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderModelManger.h"

@interface M8CallRenderModelManger (CallStatus)


/**
 有成员忙、占线
 
 @param identify 成员ID
 */
- (void)memberLineBusyWithID:(NSString * _Nonnull)identify;


/**
 有成员拒绝邀请
 
 @param identify 成员ID
 */
- (void)memberRejectInviteWithID:(NSString * _Nonnull)identify;


/**
 有成员呼叫超时
 
 @param identify 成员ID
 */
- (void)memberTimeoutWithID:(NSString * _Nonnull)identify;


/**
 有成员接受邀请
 
 @param identify 成员ID
 */
- (void)memberReceiveWithID:(NSString * _Nonnull)identify;


/**
 有成员失去连接
 
 @param identify 成员ID
 */
- (void)memberDisconnetWithID:(NSString * _Nonnull)identify;


/**
 有成员挂断电话
 
 @param identify 成员ID
 */
- (void)memberHangupWithID:(NSString * _Nonnull)identify;


/**
 有音频事件发生
 
 @param isOn 成员是否开启音频
 @param identify 成员ID
 */
- (void)onMemberAudioOn:(BOOL)isOn WithID:(NSString * _Nonnull)identify;


/**
 有视频事件发生
 
 @param isOn 成员是否开启视频
 @param identify 成员ID
 */
- (void)onMemberCameraVideoOn:(BOOL)isOn WithID:(NSString * _Nonnull)identify;

@end
