//
//  M8FloatWindowSingleton.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatWindowSingleton.h"
#import "M8FloatWindowController.h"

@implementation M8FloatWindowSingleton

+ (instancetype)Instance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (void)M8_addWindowOnTarget:(UIViewController *)target onClick:(void (^)())callback {
    M8FloatWindowController *floatVC = [[M8FloatWindowController alloc] init];
    [target addChildViewController:floatVC];
    [target.view addSubview:floatVC.view];
    [floatVC setRootView];
    _floatVC = floatVC;
    _floatWindowCallBack = callback;
}

- (void)M8_setRenderViewCall:(TILMultiCall *)call identify:(NSString *)identify {
    [_floatVC setRenderViewCall:call identify:identify];
}

@end
