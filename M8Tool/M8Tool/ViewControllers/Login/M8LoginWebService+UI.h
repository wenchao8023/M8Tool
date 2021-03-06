//
//  M8LoginWebService+UI.h
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService.h"

@interface M8LoginWebService (UI)


/**
 获取验证码失败

 @param errorInfo 错误信息
 */
- (void)onVerifyCodeFailAlertInfo:(NSString *)errorInfo;


/**
 登录失败
 
 @param errorInfo 错误信息
 */
- (void)onLoginFailAlertInfo:(NSString *)errorInfo;


/**
 注册失败
 
 @param errorInfo 错误信息
 */
- (void)onRegistFailAlertInfo:(NSString *)errorInfo;


/**
 登录成功

 @param identifier 用户ID
 @param password 密码
 */
- (void)onLoginSucc:(NSString *)identifier password:(NSString *)password;


/**
 登录模块alert

 @param msg 信息
 */
+ (void)onLoginAelrt:(NSString *)msg;

@end
