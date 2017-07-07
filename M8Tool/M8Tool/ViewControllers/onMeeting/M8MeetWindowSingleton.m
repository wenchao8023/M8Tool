//
//  M8MeetWindowSingleton.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetWindowSingleton.h"

#import "MBaseMeetViewController.h"




@interface M8MeetWindowSingleton ()

@property (nonatomic, weak, nullable) MBaseMeetViewController *baseController;


@end



@implementation M8MeetWindowSingleton

+ (instancetype)shareInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void)addMeetSource:(id)source WindowOnTarget:(UIViewController *)target
{
    self.baseController = source;
    [target addChildViewController:self.baseController];
    [target.view addSubview:self.baseController.view];
    [self.baseController setRootView];
    
    [self hiddeFloatView];
}

- (void)showFloatView
{
    [self.baseController showFloatView];
}

- (void)hiddeFloatView
{
    [self.baseController hiddeFloatView];
}




@end
