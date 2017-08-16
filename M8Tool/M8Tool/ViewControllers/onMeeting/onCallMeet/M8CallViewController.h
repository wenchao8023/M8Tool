//
//  M8CallViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseMeetViewController.h"

#import "M8CallHeaderView.h"
#import "M8CallRenderView.h"
#import "M8CallRenderNote.h"
#import "M8MeetDeviceView.h"
#import "M8NoteToolBar.h"

#import "M8CallRenderModelManger.h"
#import "M8CallRenderModelManger+CallStatus.h"

#import "M8RecvChildViewController.h"

#import "M8BaseFloatView+Call.h"

@interface M8CallViewController : M8BaseMeetViewController

@property (nonatomic, strong) TILMultiCall * _Nonnull call;

@property (nonatomic, strong, nullable) M8CallHeaderView *headerView;
@property (nonatomic, strong, nullable) M8CallRenderView *renderView;
@property (nonatomic, strong, nullable) M8MeetDeviceView *deviceView;
@property (nonatomic, strong, nullable) M8CallRenderNote *noteView;
@property (nonatomic, strong, nullable) M8MenuPushView   *menuView;
@property (nonatomic, strong, nullable) M8NoteToolBar    *noteToolBar;



/**
 用于会议接受界面的弹出提示
 */
@property (nonatomic, strong, nullable) M8RecvChildViewController *childVC;

/**
 用于接受界面的邀请信息
 */
@property (nonatomic, strong, nullable) TILCallInvitation *invitation;

/**
 判断是否是加入自己创建的会议 (发起人退出会议之后被邀请)
 */
@property (nonatomic, assign) BOOL isJoinSelf;

/**
 当前视图中成员信息（不应该在这里出现的，后面会使用 renderView 中的）
 */
@property (nonatomic, strong, nullable) NSArray *membersArray;

/**
 用于处理 renderView 的数据
 */
@property (nonatomic, strong, nonnull) M8CallRenderModelManger *renderModelManger;

/**
 判断发起人在退出界面的时候是结束通话还是取消邀请
 在使用这个参数的时候，保证用户是发起端
 */
@property (nonatomic, assign) BOOL shouldHangup;

- (void)onReceiveCall;

- (void)onRejectCall;

- (void)hangup;

/**
 邀请多个成员
 */
- (void)inviteMembers:(NSArray *_Nullable)membersArr;

/**
 邀请单个成员
 */
- (void)inviteMember:(NSString *_Nullable)memberId;


- (void)addMember:(NSString *_Nullable)member withTip:(NSString *_Nullable)tip;

- (void)addMember:(NSString *_Nullable)member withMsg:(NSString *_Nullable)msg;

@end
