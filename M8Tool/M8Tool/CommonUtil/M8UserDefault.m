//
//  M8UserDefault.m
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8UserDefault.h"

@implementation M8UserDefault

#pragma mark - 用户登录数据
#pragma mark -- kLoginIdentifier（用户ID）
+ (NSString *)getLoginId
{
    return [self returnObjectWithKey:kLoginIdentifier];
}
+ (void)setLoginId:(NSString *)loginId
{
    [self setObject:loginId key:kLoginIdentifier];
}

#pragma mark -- kLoginNick（用户昵称）
+ (NSString *)getLoginNick
{
    return [self returnObjectWithKey:kLoginNick];
}
+ (void)setLoginNick:(NSString *)loginNick
{
    [self setObject:loginNick key:kLoginNick];
}

#pragma mark -- kLoginPassward（用户密码）
+ (NSString *)getLoginPwd
{
    return [PasswordTool readPassWord];
}
+ (void)setLoginPwd:(NSString *)loginPwd
{
    [PasswordTool savePassWord:loginPwd];
}

#pragma mark -- kLastLoginType（用户上一次登录类型）
+ (LastLoginType)getLastLoginType
{
    LastLoginType loginType;
    id obj = [self returnObjectWithKey:kLastLoginType];
    [obj getValue:&loginType];
    
    return loginType;
}
+ (void)setLastLoginType:(LastLoginType)loginType
{
    [self setObject:@(loginType) key:kLastLoginType];
}


#pragma mark - QQ登录
+ (NSString *)getQQOpenId
{
    return [PasswordTool readQQOpenId];
}
+ (void)setQQOpenId:(NSString *)openId
{
    [PasswordTool saveQQOpenId:openId];
}


#pragma mark - -- kUserLogout（用户主动登出）
+ (BOOL)getIsUserLogout
{
    return [self returnBoolWithKey:kUserLogout];
}

+ (void)setUserLogout:(BOOL)userLogout
{
    [self setBoolValue:userLogout key:kUserLogout];
}

#pragma mark - -- kAppLaunching (App是否在启动中)
+ (BOOL)getAppIsLaunching
{
    return [self returnBoolWithKey:kAppLaunching];
}

+ (void)setAppLaunching:(BOOL)launching
{
    [self setBoolValue:launching key:kAppLaunching];
}


#pragma mark - 会议信息
#pragma mark -- kIsInMeeting（是否在会议中）
+ (BOOL)getIsInMeeting
{
    return [self returnBoolWithKey:kIsInMeeting];
}

+ (void)setMeetingStatu:(BOOL)isInMeeting
{
    [self setBoolValue:isInMeeting key:kIsInMeeting];
}


#pragma mark -- kPushMenuStatus（通话菜单是否被推出）
+ (BOOL)getPushMenuStatu
{
    return [self returnBoolWithKey:kPushMenuStatus];
}

+ (void)setPushMenuStatu:(BOOL)statu
{
    [self setBoolValue:statu key:kPushMenuStatus];
}


#pragma mark -- kKeyboardShow (会议中推出键盘)
+ (BOOL)getKeyboardShow
{
    return [self returnBoolWithKey:kKeyboardShow];
}

+ (void)setKeyboardShow:(BOOL)show
{
    [self setBoolValue:show key:kKeyboardShow];
}

#pragma mark -- kNewFriendNotify (判断是否有新的朋友)
+ (BOOL)getNewFriendNotify
{
    return [self returnBoolWithKey:kNewFriendNotify];
}
+ (void)setNewFriendNotify:(BOOL)notify
{
    [self setBoolValue:notify key:kNewFriendNotify];
}

#pragma mark -- kNewFriendIdentify (新的好友IDs)
+ (NSArray *)getNewFriendIdentify
{
    return [self returnObjectWithKey:kNewFriendIdentify];
}

+ (void)setNewFriendIdentify:(NSArray *)idArr
{
    [self setObject:idArr key:kNewFriendIdentify];
}


#pragma mark - 全局设置
#pragma mark -- kThemeImage（主题图片）
+ (NSString *)getThemeImageString
{
    return [self returnObjectWithKey:kThemeImage];
}
+ (void)setThemeImageString:(NSString *)imgStr
{
    [self setObject:imgStr key:kThemeImage];
}

#pragma mark -- kUserProtocol（用户协议）
+ (BOOL)getUserProtocolStatu
{
    return [self returnBoolWithKey:kUserProtocol];
}

+ (void)setUserProtocolStatu:(BOOL)statu
{
    [self setBoolValue:statu key:kUserProtocol];
}


#pragma mark -- kAppIsTerminate_Notifycatioin
+ (BOOL)getAppIsTerminate
{
    return [self returnBoolWithKey:kAppIsTerminate_Notifycatioin];
}
+ (void)setAppIsTerminate:(BOOL)isTerminate
{
    [self setBoolValue:isTerminate key:kAppIsTerminate_Notifycatioin];
}

#pragma mark - private
#pragma mark -- object value
+ (void)setObject:(id)obj key:(NSString *)key
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:obj forKey:key];
    [userD synchronize];
}

+ (id)returnObjectWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark -- bool value
+ (BOOL)returnBoolWithKey:(NSString *)key
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+ (void)setBoolValue:(BOOL)boolValue key:(NSString *)key
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setBool:boolValue forKey:key];
    [userD synchronize];
}






@end
