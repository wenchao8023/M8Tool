//
//  M8LoginWebService+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService+UI.h"

#import "MainTabBarController.h"
#import "UserProtocolViewController.h"

@implementation M8LoginWebService (UI)


- (void)onLoginFailAlertInfo:(NSString *)errorInfo {
    [self onLoginAlert:@"登录失败" message:errorInfo];
}

- (void)onRegistFailAlertInfo:(NSString *)errorInfo {
    [self onLoginAlert:@"注册失败" message:errorInfo];
}

- (void)onLoginAlert:(NSString *)title message:(NSString *)msg {
    [AlertHelp alertWith:title message:msg cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
}


- (void)onLoginSucc:(NSString *)identifier password:(NSString *)password {
    
    // 保存用户信息到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:identifier forKey:kLoginIdentifier];
    [userDefaults setObject:password forKey:kLoginPassward];
    [userDefaults synchronize];
    
    // 进入主界面
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSNumber *has = [[NSUserDefaults standardUserDefaults] objectForKey:kUserProtocol];
    if (!has || !has.boolValue)
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
