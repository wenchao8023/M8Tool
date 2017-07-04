//
//  MMeetWindowSingleton.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MMeetWindowSingleton.h"

#import "MBaseMeetViewController.h"




@interface MMeetWindowSingleton ()

@property (nonatomic, weak, nullable) MBaseMeetViewController *baseController;
@property (nonatomic, weak, nullable) UIWindow *meetWindow;

@end



@implementation MMeetWindowSingleton

+ (instancetype)shareInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self meetWindow];
    }
    return self;
}

- (UIWindow *)meetWindow {
    if (!_meetWindow) {
        UIWindow *meetWindow = [[UIWindow alloc] init];
        meetWindow.frame = [UIScreen mainScreen].bounds;
        meetWindow.windowLevel = UIWindowLevelAlert + 1;
        meetWindow.backgroundColor = [UIColor clearColor];
        [meetWindow makeKeyAndVisible];
        
        _meetWindow = meetWindow;
    }
    return _meetWindow;
}


- (void)addMeetSource:(MBaseMeetViewController *)source
{
    _baseController = source;
    self.meetWindow.rootViewController = _baseController;
}


@end
