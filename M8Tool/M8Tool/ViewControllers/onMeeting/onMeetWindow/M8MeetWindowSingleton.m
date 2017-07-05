//
//  M8MeetWindowSingleton.m
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetWindowSingleton.h"

//#import "M8MeetWindowController.h"

#import "M8CallBaseViewController.h"
#import "M8LiveBaseViewController.h"



@interface M8MeetWindowSingleton ()

@property (nonatomic, weak, nullable) M8CallBaseViewController *callViewController;
@property (nonatomic, weak, nullable) M8LiveBaseViewController *liveViewController;

//@property (nonatomic, weak, nullable) M8MeetWindowController *windowController;
//@property (nonatomic, weak, nullable) UIWindow *meetWindow;

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

- (instancetype)init {
    if (self = [super init]) {
//        [self meetWindow];
//        [self windowController];
    }
    return self;
}


//- (M8MeetWindowController *)windowController {
//    if (!_windowController) {
//        M8MeetWindowController *windowController = [[M8MeetWindowController alloc] init];
//        _windowController = windowController;
//    }
//    return _windowController;
//}

//- (UIWindow *)meetWindow {
//    if (!_meetWindow) {
//        UIWindow *meetWindow = [[UIWindow alloc] init];
//        meetWindow.frame = [UIScreen mainScreen].bounds;
//        meetWindow.windowLevel = UIWindowLevelAlert + 1;
//        meetWindow.backgroundColor = [UIColor clearColor];
//        [meetWindow makeKeyAndVisible];
//        
//        meetWindow.rootViewController = self.windowController;
//        
//        _meetWindow = meetWindow;
//    }
//    return _meetWindow;
//}

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


- (void)showFloatView {
    if (_callViewController) {
        [self.callViewController showFloatView];
    }
    else if (_liveViewController) {
        [self.liveViewController showFloatView];
    }
}

- (void)hiddeFloatView {
    if (_callViewController) {
        [self.callViewController hiddeFloatView];
    }
    else if (_liveViewController) {
        [self.liveViewController hiddeFloatView];
    }
}

@end
