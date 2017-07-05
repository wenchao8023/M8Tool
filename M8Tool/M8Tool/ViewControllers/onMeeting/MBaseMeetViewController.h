//
//  MBaseMeetViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBaseFloatView.h"


/**
 会议界面
 
 提供切换窗口、退出接口
 */
@interface MBaseMeetViewController : UIViewController

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
@property (nonatomic, strong, nonnull) UIImageView          *bgImageView;

/**
 退出按钮
 */
@property (nonatomic, strong, nullable) UIButton *exitButton;

/**
 小窗口
 */
@property (nonatomic, strong, nullable) MBaseFloatView *floatView;

/**
 用 liveItem 初始化
 */
- (instancetype _Nonnull )initWithItem:(id _Nonnull)item;

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

@end
