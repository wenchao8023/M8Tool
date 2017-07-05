//
//  MBaseFloatView.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 用于显示用户的视频流信息
 */
@protocol MFloatViewDelegate <NSObject>

/**
 父视图的中心位置
 
 @param center 中心坐标
 */
- (void)MFloatViewCenter:(CGPoint)center;
- (void)MFloatViewDidClick;

@end


@interface MBaseFloatView : UIView

@property (nonatomic, strong, nullable) UIView *rootView;
@property (nonatomic, weak) id<MFloatViewDelegate> _Nullable WCDelegate;
@property (nonatomic, assign) UIInterfaceOrientation initOrientation;
@property (nonatomic, assign) CGAffineTransform originTransform;

- (void)floatViewRotate;

@end
