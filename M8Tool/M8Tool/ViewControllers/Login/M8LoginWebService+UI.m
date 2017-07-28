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

- (void)onVerifyCodeFailAlertInfo:(NSString *)errorInfo
{
    [self onLoginAlert:nil message:errorInfo];
}

- (void)onLoginFailAlertInfo:(NSString *)errorInfo
{
    [self onLoginAlert:@"登录失败" message:errorInfo];
}

- (void)onRegistFailAlertInfo:(NSString *)errorInfo
{
    [self onLoginAlert:@"注册失败" message:errorInfo];
}

- (void)onLoginAlert:(NSString *)title message:(NSString *)msg
{
    [AlertHelp alertWith:title message:msg cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
}


- (void)onLoginSucc:(NSString *)identifier password:(NSString *)password
{
    // 保存用户信息到本地
    [M8UserDefault setLoginId:identifier];
    [M8UserDefault setLoginPwd:password];
    
    // 进入主界面
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

+ (void)onLoginAelrt:(NSString *)msg {
    [AlertHelp alertWith:nil message:msg cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
}

@end
