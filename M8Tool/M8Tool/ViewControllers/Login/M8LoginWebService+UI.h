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
- (void)onVerifyCodeFailAlertInfo:(NSString *_Nullable)errorInfo;


/**
 登录失败
 
 @param errorInfo 错误信息
 */
- (void)onLoginFailAlertInfo:(NSString *_Nullable)errorInfo;


/**
 注册失败
 
 @param errorInfo 错误信息
 */
- (void)onRegistFailAlertInfo:(NSString *_Nullable)errorInfo;

/**
 修改密码失败

 @param errorInfo 错误信息
 */
- (void)onResetPwdAlertInfo:(NSString *_Nullable)errorInfo;

/**
 登录成功

 @param identifier 用户ID
 @param password 密码
 */
- (void)onLoginSucc:(NSString *_Nullable)identifier password:(NSString *_Nullable)password;


/**
 登录模块alert

 @param msg 信息
 */
+ (void)onLoginAelrt:(NSString *_Nullable)msg;

@end
