//
//  M8CallBaseViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M8MeetHeaderView.h"
#import "M8MeetDeviceView.h"

#import "M8CallRenderView.h"


/**
 会议界面
 
 添加头部 和 设备界面
 他们的代理需要在子类中对应自己的逻辑自行实现
 */
@interface M8CallBaseViewController : UIViewController<MeetHeaderDelegate, MeetDeviceDelegate, CallRenderDelegate>

/**
 背景图片
 */
@property (nonatomic, strong, nullable) UIImageView *bgImageView;

@property (nonatomic, strong, nonnull) M8MeetHeaderView *headerView;
@property (nonatomic, strong, nonnull) M8MeetDeviceView *deviceView;

@property (nonatomic, strong, nonnull) M8CallRenderView *renderView;

@property (nonatomic, strong, nonnull) TILMultiCall *_call;


/**
 添加调试信息

 @param newText 调试内容
 */
- (void)addTextToView:(NSString *_Nonnull)newText;

/**
 退出视图，为了看到调试信息，延时 1s 退出
 */
- (void)selfDismiss;
@end
