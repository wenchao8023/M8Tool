//
//  AppDelegate+ControlViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (ControlViewController)



@property (nonatomic, copy) NSString *token;
+ (instancetype)sharedAppDelegate;

- (UINavigationController *)navigationViewController;
- (UIViewController *)topViewController;
- (NSArray *)popToRootViewController;
- (UIViewController *)popViewController;
- (NSArray *)popToViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewControllerWithBottomBarHidden:(UIViewController *)viewController;

/**
 模态推出视图控制器

 @param viewController 视图控制器
 */
- (void)presentViewController:(UIViewController *)viewController ;

/**
 模态推出导航控制器，主要用于发起会议时

 @param naviController 导航控制器
 */
- (void)presentNavigationController:(UIViewController *)naviController ;

/**
 用于获取测试用的房间号

 @return 房间号
 */
- (int)getRoomID;
@end
