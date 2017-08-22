//
//  M8CallRenderModelManger.h
//  M8Tool
//
//  Created by chao on 2017/7/20.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


@class M8CallRenderModel;


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

/**
 *  初始化
 *
 *  @param item 会议中的信息
 *
 *  @return ModelManger
 */
- (instancetype _Nullable)initWithItem:(TCShowLiveListItem *_Nullable)item;


/**
 *  加载邀请的信息
 *
 *  @param members call 中邀请的信息
 */
- (void)loadInvitedArray:(NSArray *_Nullable)members;


/**
 *  用户手动切换视图
 *
 *  @param indexPath 点击下标
 *
 *  @return 房间中是否有视频流
 */
- (BOOL)onSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath;


/**
 *  用户对不在房间中的成员的操作
 *
 *  @param identify  被操作的成员
 *  @param actionStr 方法名
 */
- (void)memberUserAction:(NSString *_Nonnull)identify onAction:(NSString *_Nonnull)actionStr;


/**
 *  用户操作不在房间的成员
 *
 *  @param selectedModel 将用户选中的 Model 传给 ModelManger
 */
- (void)onCollectionDidSelectModel:(id _Nullable)selectedModel;


/**
 *  从浮动视图返回到主视图
 */
- (void)onBackFromFloatView;


/**
 *  获取 host 的摄像头状态
 *
 *  @return host 的摄像头是否打开
 */
- (BOOL)onGetHostCameraStatu;


/**
 *  返回在界面中的成员
 *
 *  @return 界面中的成员 M8CallRenderModel
 */
- (NSArray *_Nullable)membersInRoom;


/**
 *  添加从通讯录获取成员
 */
- (void)onInviteMembers;



/**
 *  获取用户昵称
 *
 *  @param uid 用户ID
 *
 *  @return 用户昵称
 */
- (NSString *_Nullable)toNickWithUid:(NSString *_Nullable)uid;


/**
 *  类别中使用的方法
 */
- (M8CallRenderModel *_Nullable)getMemberWithID:(NSString *_Nullable)identify;

- (void)updateMember:(M8CallRenderModel *_Nullable)newModel;
@end
