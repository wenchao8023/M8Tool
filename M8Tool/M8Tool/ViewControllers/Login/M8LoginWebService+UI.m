//
//  M8LoginWebService+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService+UI.h"



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

- (void)onResetPwdAlertInfo:(NSString *)errorInfo
{
    [self onLoginAlert:@"修改密码失败" message:errorInfo];
}

- (void)onLoginAlert:(NSString *)title message:(NSString *)msg
{
    [AlertHelp alertWith:title message:msg cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
}


- (void)onLoginSucc:(NSString *)identifier password:(NSString *)password
{
    [M8UserDefault setUserLogout:NO];
    [M8UserDefault setLastLoginType:LastLoginType_phone];
    
    // 保存用户信息到本地
    [M8UserDefault setLoginId:identifier];
    [M8UserDefault setLoginPwd:password];
    
    // 进入主界面
    [[AppDelegate sharedAppDelegate] enterMainUI];
}



- (void)onQQLoginSucc:(NSString *)openId
{
    [M8UserDefault setUserLogout:NO];
    [M8UserDefault setLastLoginType:LastLoginType_QQ];
    
    [M8UserDefault setLoginId:openId];
    
    // 进入主界面
    [[AppDelegate sharedAppDelegate] enterMainUI];
}

+ (void)onLoginAelrt:(NSString *)msg
{
    [AlertHelp alertWith:nil message:msg cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
}

@end
