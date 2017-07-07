//
//  M8BaseFloatView+Call.h
//  M8Tool
//
//  Created by chao on 2017/7/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseFloatView.h"

@interface M8BaseFloatView (Call)

- (void)configCallFloatView:(TCShowLiveListItem *_Nonnull)item isCameraOn:(BOOL)isCameraOn;


/**
 接收端在观看浮动视图的时候
 发起端进行了摄像头开关操作

 @param isOn 摄像头状态
 */
- (void)onCallVideoListener:(BOOL)isOn;

@end
