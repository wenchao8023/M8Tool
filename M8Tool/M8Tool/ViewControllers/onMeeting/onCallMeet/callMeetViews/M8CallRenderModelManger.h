//
//  M8CallRenderModelManger.h
//  M8Tool
//
//  Created by chao on 2017/7/20.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RenderModelMangerDelegate <NSObject>

@optional

/**
 视频流Modeldelegate

 @param renderModelManger   self
 @param bgViewIdentify      处在背景视图用户ID，如果为空则表示没有视频流
 @param renderViewArray     处在renderView中的成员
 */
- (void)renderModelManager:(id _Nonnull)renderModelManger
            bgViewIdentify:(NSString *_Nullable)bgViewIdentify
           renderViewArray:(NSArray *_Nullable)renderViewArray;

- (void)renderModelManger:(id _Nonnull)renderModelManger
             inviteMember:(NSString *_Nullable)inviteMemberId;

@end


@interface M8CallRenderModelManger : NSObject


@property (nonatomic, weak) id<RenderModelMangerDelegate> _Nullable WCDelegate;


- (instancetype _Nullable)initWithItem:(TCShowLiveListItem *_Nullable)item;


/**
 如果 单例中 的inviteArray变化了，就需要调用这个接口重新
 */
- (void)initInviteArray;

/**
 有成员发送通知消息
 
 @param identify 成员ID
 */
//- (void)memberNotifyWithID:(NSString * _Nonnull)identify;


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


- (void)memberUserAction:(NSString *_Nonnull)identify onAction:(NSString *_Nonnull)actionStr;

/**
 用户点击cell

 @param selectedModel 将用户选中的 Model 传给 ModelManger
 */
- (void)onCollectionDidSelectModel:(id _Nullable)selectedModel;

/**
 从浮动视图返回到主视图
 */
- (void)onBackFromFloatView;

/**
 获取 host 的摄像头状态
 */
- (BOOL)onGetHostCameraStatu;

/**
 添加从通讯录获取成员
 */

- (void)onInviteMembers;


- (NSString *_Nullable)toNickWithUid:(NSString *_Nullable)uid;

@end
