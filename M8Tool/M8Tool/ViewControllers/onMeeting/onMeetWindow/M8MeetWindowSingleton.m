//
//  M8MeetWindowSingleton.m
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetWindowSingleton.h"

#import "M8CallBaseViewController.h"




@implementation M8MeetWindowSingleton

+ (instancetype)getInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
//        _callViewController = [[M8CallBaseViewController alloc] init];
    }
    return self;
}


/**
 只调用一次

 @param target 目标视图控制器
 */
- (void)addSource:(M8CallBaseViewController *)source WindowOnTarget:(UIViewController *)target {
    _callViewController = source;
    [target addChildViewController:_callViewController];
    [target.view addSubview:_callViewController.view];
    [_callViewController setRootView];
    
    [self hiddeFloatView];
}

- (void)showFloatView {
    [_callViewController showFloatView];
}
- (void)hiddeFloatView {
    [_callViewController hiddeFloatView];
}

@end
