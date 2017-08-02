//
//  M8LoginWebService.h
//  M8Tool
//
//  Created by chao on 2017/6/30.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^M8LoginHandle)();

@interface M8LoginWebService : NSObject

/**
 登录
 
 @param identifier 用户
 @param password 密码
 @param cancelHandle 取消加载视图
 */
- (void)M8LoginWithIdentifier:(NSString *_Nonnull)identifier
                     password:(NSString *_Nonnull)password
                    cancelPVN:(M8LoginHandle _Nullable)cancelHandle;

/**
 重新登录
 
 @param identifier 用户
 @param password 密码
 @param cancelHandle 取消加载视图
 */
- (void)M8ReLoginWithIdentifier:(NSString *_Nonnull)identifier
                     password:(NSString *_Nonnull)password
                    cancelPVN:(M8LoginHandle _Nullable)cancelHandle;

/**
 sig过期，重新登录获取新的sig (暂时没用到)
 
 @param identifier 用户
 @param password 密码
 */
- (void)M8LoginToGetSigWithIdentifier:(NSString * _Nullable)identifier
                             password:(NSString * _Nullable)password;


/**
 App自动登录
 
 @param identifier 用户
 @param password 密码
 */
- (void)M8AutoLoginWithIdentifier:(NSString * _Nullable)identifier
                         password:(NSString * _Nullable)password
                       failHandle:(M8LoginHandle _Nullable)failHandle;

//QQ登录
- (void)M8QQLoginWithOpenId:(NSString *_Nullable)openId
                       nick:(NSString *_Nullable)nick
                  cancelPVN:(M8LoginHandle _Nullable)cancelHandle;

//被踢下线重新登录
- (void)M8QQReLoginWithOpenId:(NSString *_Nullable)openId
                         nick:(NSString *_Nullable)nick
                    cancelPVN:(M8LoginHandle _Nullable)cancelHandle;

//启动App 自动登录
- (void)M8QQAutoLoginWithOpenId:(NSString *_Nullable)openId
                           nick:(NSString *_Nullable)nick
                     failHandle:(M8LoginHandle _Nullable)failHandle;





/**
 获取验证码

 @param phoneNumber 手机号
 */
- (void)M8GetVerifyCode:(NSString *_Nonnull)phoneNumber
             succHandle:(M8LoginHandle _Nullable)succHandle;


/**
 验证验证码

 @param phoneNum 手机号
 @param verifyCode 验证码
 */
- (void)M8VerifyVerifyCode:(NSString *_Nonnull)phoneNum
                verifyCode:(NSString *_Nonnull)verifyCode
                succHandle:(M8LoginHandle _Nullable)succHandle
                failHandle:(M8LoginHandle _Nullable)failHandle;



/**
 注册
 
 @param identifier  用户ID
 @param nick        昵称
 @param pwd         密码
 @param veriCode    验证码
 @param cancelHandle 取消加载视图
 */
- (void)M8RegistWithIdentifier:(NSString *_Nonnull)identifier
                          nick:(NSString *_Nonnull)nick
                           pwd:(NSString *_Nonnull)pwd
                      veriCode:(NSString *_Nonnull)veriCode
                  cancelHandle:(M8LoginHandle _Nullable)cancelHandle;


/**
 修改密码

 @param phoneNumber 手机号
 @param pwd         新密码
 @param veriCode    验证码
 @param cancelHandle 取消加载视图
 */
- (void)m8ResetPwdWithPhoneNumber:(NSString *_Nonnull)phoneNumber
                              pwd:(NSString *_Nonnull)pwd
                         veriCode:(NSString *_Nonnull)veriCode
                     cancelHandle:(M8LoginHandle _Nullable)cancelHandle;

@end
