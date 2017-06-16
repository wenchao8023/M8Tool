//
//  M8FloatWindow.h
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8FloatWindow : NSObject

/* add the floaitng window to the target and the callback block will be excuted when click the button */
+ (void)M8_addWindowOnTarget:(nonnull id)target onClick:(nullable void(^)())callback;
/* you can resize the view's size, 50 by default if you don't set it */
//+ (void)M8_setWindowSize:(float)size;
///* you can hide the view or show it again */
//+ (void)M8_setHideWindow:(BOOL)hide;
+ (void)M8_setRenderViewCall:(TILMultiCall *)call identify:(NSString *)identify;

@end
