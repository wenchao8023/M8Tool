//
//  M8FloatRenderView.h
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 用于显示用户的视频流信息
 */
@protocol FloatRenderViewDelegate <NSObject>

/**
 父视图的中心位置

 @param center 中心坐标
 */
- (void)floatRenderViewCenter:(CGPoint)center;
- (void)floatRenderViewDidClicked;

@end


@interface M8FloatRenderView : UIView

@property (nonatomic, strong, nullable) UIView *rootView;
@property (nonatomic, weak) id<FloatRenderViewDelegate> _Nullable WCDelegate;
@property (nonatomic, assign) UIInterfaceOrientation initOrientation;
@property (nonatomic, assign) CGAffineTransform originTransform;

- (void)floatViewRotate;

- (void)configWithRenderModel:(id _Nonnull)model;

@end
