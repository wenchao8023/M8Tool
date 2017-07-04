//
//  M8MeetWindow.h
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8MeetWindow : NSObject

+ (void)M8_addCallSource:(nonnull id)source WindowOnTarget:(nonnull id)target;
+ (void)M8_addLiveSource:(nonnull id)source WindowOnTarget:(nonnull id)target;
+ (void)M8_showFloatView;
+ (void)M8_hiddeFloatView;

@end
