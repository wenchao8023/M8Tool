//
//  M8BaseMeetViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M8BaseFloatView.h"

#import "M8MenuPushView.h"




/**
 会议界面
 
 提供切换窗口、退出接口
 */
@interface M8BaseMeetViewController : UIViewController<M8FloatViewDelegate>


/**
 用 liveItem 初始化
 */
- (instancetype _Nonnull )initWithItem:(id _Nonnull)item isHost:(BOOL)isHost;


/**
 记录直播(包含通话)信息
 */
@property (nonatomic, strong, nullable) TCShowLiveListItem *liveItem;


/**
  *  通话中 - 发起端
  *  直播中 - 主播端
  */
@property (nonatomic, assign) BOOL isHost;


/**
 背景图片
 */
@property (nonatomic, strong, nonnull) UIImageView *bgImageView;


/**
 退出按钮, 按钮点击事件由子类实现
 */
@property (nonatomic, strong, nullable) UIButton *exitButton;


/**
 小窗口
 */
@property (nonatomic, strong, nullable) M8BaseFloatView *floatView;


/**
 判断视频流信息是否在浮动窗口
 */
@property (nonatomic, assign) BOOL isInFloatView;


/**
 设置floatView的相对位置
 */
- (void)setRootView;


/**
 显示floatView
 */
- (void)showFloatView;


/**
 隐藏floatView
 */
- (void)hiddeFloatView;


/**
 退出
 */
- (void)selfDismiss;



#pragma mark - 推流


@property (nonatomic, assign) UInt64 pushID;    //记录推流ID
/**
 开始推流
 */
- (void)onLivePushStart;

/**
 停止推流
 */
- (void)onLivePushStop;
@end
