//
//  M8BaseFloatView.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 用于显示用户的视频流信息
 */
@protocol M8FloatViewDelegate <NSObject>

/**
 父视图的中心位置
 
 @param center 中心坐标
 */
@optional
- (void)M8FloatView:(id _Nonnull)floatView centerChanged:(CGPoint)center;
- (void)M8FloatView:(id _Nonnull)floatView centerEnded:(CGPoint)center;

@required
- (void)M8FloatViewDidClick;

@end


@interface M8BaseFloatView : UIView

@property (nonatomic, strong, nullable) UIView *rootView;
@property (nonatomic, weak) id<M8FloatViewDelegate> _Nullable WCDelegate;
@property (nonatomic, assign) UIInterfaceOrientation initOrientation;
@property (nonatomic, assign) CGAffineTransform originTransform;

- (void)floatViewRotate;


@property (weak, nonatomic) IBOutlet UIVisualEffectView * _Nullable effectView;

@property (weak, nonatomic) IBOutlet M8LiveLabel * _Nullable meetTypeLabel;

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable onVoiceImg;


@property (weak, nonatomic) IBOutlet M8LiveLabel * _Nullable hostLabel;


@end
