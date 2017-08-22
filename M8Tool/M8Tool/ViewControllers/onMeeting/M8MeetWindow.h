//
//  M8MeetWindow.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M8MeetWindow : UIWindow
+ (void)M8_addMeetSource:(nonnull id)source WindowOnTarget:(nonnull id)target;
+ (void)M8_addMeetSource:(nonnull id)source WindowOnTarget:(nonnull id)target succHandle:(M8VoidBlock _Nullable)succ;
+ (void)M8_showFloatView;
+ (void)M8_hiddeFloatView;

@end
