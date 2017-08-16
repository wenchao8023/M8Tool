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


- (instancetype _Nullable)initWithItem:(TCShowLiveListItem *_Nullable)item;


- (void)loadInvitedArray:(NSArray *_Nullable)members;


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



/**
 类别中使用的方法
 */
- (M8CallRenderModel *_Nullable)getMemberWithID:(NSString *_Nullable)identify;

- (void)updateMember:(M8CallRenderModel *_Nullable)newModel;
@end
