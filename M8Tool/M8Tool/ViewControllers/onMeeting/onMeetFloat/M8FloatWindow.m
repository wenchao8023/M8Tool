//
//  M8FloatWindow.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatWindow.h"
#import "M8FloatWindowSingleton.h"

@implementation M8FloatWindow

+ (void)M8_addWindowOnTarget:(id)target onClick:(void (^)())callback {
    [[M8FloatWindowSingleton Instance] M8_addWindowOnTarget:target onClick:callback];
}

+ (void)M8_setRenderViewCall:(TILMultiCall *)call identify:(NSString *)identify {
    [[M8FloatWindowSingleton Instance] M8_setRenderViewCall:call identify:identify];
}

@end
