//
//  MMeetWindow.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMeetWindow : UIWindow

+ (void)M_addMeetSource:(nonnull id)source WindowOnTarget:(nonnull id)target;
+ (void)M_showFloatView;
+ (void)M_hiddeFloatView;

@end
