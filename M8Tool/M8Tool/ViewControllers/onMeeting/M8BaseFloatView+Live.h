//
//  M8BaseFloatView+Live.h
//  M8Tool
//
//  Created by chao on 2017/7/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseFloatView.h"

@interface M8BaseFloatView (Live)

- (void)configLiveFloatView:(TCShowLiveListItem *_Nonnull)item isCameraOn:(BOOL)isCameraOn;

- (void)onLiveVideoListener:(BOOL)isOn;

@end
