//
//  M8MeetWindowSingleton.m
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetWindowSingleton.h"

#import "M8CallBaseViewController.h"
#import "M8LiveBaseViewController.h"



@interface M8MeetWindowSingleton ()

@property (nonatomic, strong, nullable) M8CallBaseViewController *callViewController;
@property (nonatomic, strong, nullable) M8LiveBaseViewController *liveViewController;

@end


@implementation M8MeetWindowSingleton

+ (instancetype)getInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (M8CallBaseViewController *)callViewController {
    if (!_callViewController) {
        M8CallBaseViewController *callBaseViewController = [[M8CallBaseViewController alloc] init];
        _callViewController = callBaseViewController;
    }
    return _callViewController;
}

- (M8LiveBaseViewController *)liveViewController {
    if (!_liveViewController) {
        M8LiveBaseViewController *liveViewController = [[M8LiveBaseViewController alloc] init];
        _liveViewController = liveViewController;
    }
    return _liveViewController;
}

/**
 只调用一次

 @param target 目标视图控制器
 */
- (void)addCallSource:(M8CallBaseViewController *)source WindowOnTarget:(UIViewController *)target {
    self.callViewController = source;
    [target addChildViewController:self.callViewController];
    [target.view addSubview:self.callViewController.view];
    [self.callViewController setRootView];
    
    [self hiddeFloatView];
}

- (void)addLiveSource:(id _Nonnull)source WindowOnTarget:(UIViewController *_Nonnull)target {
    self.liveViewController = source;
    [target addChildViewController:self.liveViewController];
    [target.view addSubview:self.liveViewController.view];
    [self.liveViewController setRootView];
    
    [self hiddeFloatView];
}

#warning 这里需要判断是直播还是通话
- (void)showFloatView {
    if (_callViewController) {
        [self.callViewController showFloatView];
    }
    else {
        [self.liveViewController showFloatView];
    }
    
}
#warning 这里需要判断是直播还是通话
- (void)hiddeFloatView {
    if (_callViewController) {
        [self.callViewController hiddeFloatView];
    }
    else {
        [self.liveViewController hiddeFloatView];
    }
}

@end
