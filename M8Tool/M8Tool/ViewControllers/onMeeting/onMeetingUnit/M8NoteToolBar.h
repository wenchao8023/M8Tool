//
//  M8NoteToolBar.h
//  M8Tool
//
//  Created by chao on 2017/7/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol M8NoteToolBarDelegate <NSObject>

// 键盘的位置 去设置 tableView 的位置 带动画时间和效果 保证三个控件的动画是一致的
- (void)noteToolBarOriginY:(CGFloat)originY isHidden:(BOOL)ishidden animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)curve;

- (void)noteToolBarSendMsg:(NSString *_Nullable)msg;

@end


@interface M8NoteToolBar : UIToolbar


@property (nonatomic, weak) id<M8NoteToolBarDelegate> _Nullable WCDelegate;

- (void)onBeginEditingAction;

- (void)onEndEditingAction;

@end
