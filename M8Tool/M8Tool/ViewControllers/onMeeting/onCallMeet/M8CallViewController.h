//
//  M8CallViewController.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MBaseMeetViewController.h"

#import "M8CallHeaderView.h"
#import "M8CallRenderView.h"
#import "M8DeviceView.h"

#import "M8CallRenderModelManager.h"

@interface M8CallViewController : MBaseMeetViewController

@property (nonatomic, strong) TILMultiCall * _Nonnull call;

@property (nonatomic, strong, nonnull) M8CallHeaderView     *headerView;
@property (nonatomic, strong, nonnull) M8CallRenderView     *renderView;
@property (nonatomic, strong, nonnull) M8DeviceView         *deviceView;



/**
 当前的会议ID
 */
@property (nonatomic, assign) int curMid;

/**
 用于处理 renderView 的数据
 */
@property (nonatomic, strong, nonnull) M8CallRenderModelManager *modelManager;

/**
 判断发起人在退出界面的时候是结束通话还是取消邀请
 */
@property (nonatomic, assign) BOOL shouldHangup;


- (void)addTextToView:(id _Nullable )newText;

@end
