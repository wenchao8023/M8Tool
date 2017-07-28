//
//  M8UserDefault.h
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8UserDefault : NSObject


/**
 获取登录的用户名

 @return 用户名（用以保存手机号）
 */
+ (NSString *_Nullable)getLoginId;
+ (void)setLoginId:(NSString *_Nullable)loginId;

/**
 获取登录的用户昵称
 
 @return 用户昵称
 */
+ (NSString *_Nullable)getLoginNick;
+ (void)setLoginNick:(NSString *_Nullable)loginNick;

/**
 获取登录的用户密码
 
 @return 用户密码）
 */
+ (NSString *_Nullable)getLoginPwd;
+ (void)setLoginPwd:(NSString *_Nullable)loginPwd;

/**
 获取手机主题图片
 
 @return 主题图片
 */
+ (NSString *_Nullable)getThemeImageString;
+ (void)setThemeImageString:(NSString *_Nullable)imgStr;

/**
 获取用户协议是否阅读
 
 @return 用户协议阅读状态
 */
+ (BOOL)getUserProtocolStatu;
+ (void)setUserProtocolStatu:(BOOL)statu;

/**
 判断是否在会议中
 */
+ (BOOL)getIsInMeeting;
+ (void)setMeetingStatu:(BOOL)isInMeeting;

/**
 判断会议中推出菜单状态
 */
+ (BOOL)getPushMenuStatu;
+ (void)setPushMenuStatu:(BOOL)statu;


/**
 判断是否有新的朋友添加
 */
+ (BOOL)getNewFriendNotify;
+ (void)setNewFriendNotify:(BOOL)notify;


/**
 获取新的好友ID
 */
+ (NSArray *_Nullable)getNewFriendIdentify;
+ (void)setNewFriendIdentify:(NSArray *_Nullable)idArr;

/**
 会议中推出键盘状态
 */
+ (BOOL)getKeyboardShow;
+ (void)setKeyboardShow:(BOOL)show;

@end
