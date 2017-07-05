//
//  M8CallRenderModelManager.h
//  M8Tool
//
//  Created by chao on 2017/6/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RenderModelManagerDelegate <NSObject>

- (void)renderModelManager:(id _Nonnull)modelManager
              currentModel:(id _Nullable)currentModel
              membersArray:(NSArray *_Nullable)membersArray;

@optional
- (void)renderModelManager:(id _Nonnull)modelManager
         currentIdentifier:(NSString *_Nullable)curId
              membersArray:(NSArray *_Nullable)membersArray;

@end


@interface M8CallRenderModelManager : NSObject

@property (nonatomic, copy, nullable) NSString *hostIdentify;

@property (nonatomic, copy, nullable) NSString *loginIdentify;

@property (nonatomic, assign) TILCallType callType;

@property (nonatomic, weak) id _Nullable WCDelegate;



/**
 有成员发送通知消息

 @param identify 成员ID
 */
- (void)memberNotifyWithID:(NSString * _Nonnull)identify;


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
 有成员离开房间
 
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


/**
 用户手动切换视图

 @param indexPath 点击下标
 */
- (BOOL)onSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

@end



















