//
//  AppDelegate+ControlViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate+ControlViewController.h"
#import "MainTabBarController.h"
#import "UserProtocolViewController.h"




@implementation AppDelegate (ControlViewController)

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - push
- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewControllerWithBottomBarHidden:(UIViewController *)viewController
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController animated:YES];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @autoreleasepool
    {
        BOOL isMeeting = [M8UserDefault getIsInMeeting];
        if (isMeeting) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        [[self navigationViewController] pushViewController:viewController animated:animated];
    }
}

#pragma mark - model
- (void)presentViewController:(UIViewController *)viewController
{
    @autoreleasepool
    {
        [[self navigationViewController] presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)presentNavigationController:(UIViewController *)naviController
{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:naviController];
    [self presentViewController:navi];
}

- (UIViewController *)popViewController
{
    return [[self navigationViewController] popViewControllerAnimated:YES];
}

- (NSArray *)popToRootViewController
{
    return [[self navigationViewController] popToRootViewControllerAnimated:NO];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
{
    return [[self navigationViewController] popToViewController:viewController animated:YES];
}

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController
{
    UIWindow *window = self.window;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)window.rootViewController;
    }
    else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    
    return nil;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self navigationViewController];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


- (void)enterLoginUI
{
    UINavigationController *navi = kM8LoginNaViewController(kM8MutiLoginViewController);
    UIViewController *bottomVC   = kM8LoginSBViewController(kM8MutiLoginViewController);
    UIViewController *topVC      = kM8LoginSBViewController(kM8LoginViewController);
    navi.viewControllers = @[bottomVC, topVC];
    
    self.window.rootViewController = navi;
    [self.window makeKeyWindow];
}

- (void)enterLoginMutiUI
{
    UINavigationController *navi = kM8LoginNaViewController(kM8MutiLoginViewController);
    
    self.window.rootViewController = navi;
    [self.window makeKeyWindow];
}

- (void)enterMainUI
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![M8UserDefault getUserProtocolStatu])
    {
        UserProtocolViewController *vc = [[UserProtocolViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        appDelegate.window.rootViewController = nav;
        return;
    }
    MainTabBarController *tabBarVC = [[MainTabBarController alloc] init];
    appDelegate.window.rootViewController = tabBarVC;
}



@end
