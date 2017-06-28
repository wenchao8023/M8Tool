//
//  M8LiveBaseViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "M8FloatRenderView.h"
#import "M8LivePlayView.h"
#import "M8LiveInfoView.h"



@interface M8LiveBaseViewController : UIViewController
/**
 背景图片
 */
@property (nonatomic, strong, nonnull) UIImageView          *bgImageView;
/**
 显示主播图像
 */
@property (nonatomic, strong) M8LivePlayView * _Nullable livingPlayView;
/**
 显示直播间信息
 */
@property (nonatomic, strong) M8LiveInfoView * _Nullable livingInfoView;


@property (nonatomic, strong, nullable) M8FloatRenderView    *floatView;

@property (nonatomic, strong, nonnull) TILMultiCall *_call;

@property (nonatomic, copy, nonnull) NSString *topic;

/**
 判断是否是浮动视图显示，如果是，则不会在 renderView 中修改位置
 */
@property (nonatomic, assign) BOOL isFloatView;
/**
 添加调试信息
 
 @param newText 调试内容
 */
//- (void)addTextToView:(NSString *_Nonnull)newText;

/**
 退出视图，为了看到调试信息，延时 1s 退出
 */
- (void)selfDismiss;

#pragma mark - 设置window窗口
- (void)showFloatView;

- (void)hiddeFloatView;

- (void)setRootView;


@end
