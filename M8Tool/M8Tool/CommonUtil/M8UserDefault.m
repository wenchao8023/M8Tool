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
    return [self returnStringWithKey:kLoginIdentifier];
}
+ (void)setLoginId:(NSString *)loginId
{
    [self setObject:loginId key:kLoginIdentifier];
}

#pragma mark -- kLoginNick（用户昵称）
+ (NSString *)getLoginNick
{
    return [self returnStringWithKey:kLoginNick];
}
+ (void)setLoginNick:(NSString *)loginNick
{
    [self setObject:loginNick key:kLoginNick];
}

#pragma mark -- kLoginPassward（用户密码）
+ (NSString *)getLoginPwd
{
//    return [self returnStringWithKey:kLoginPassward];
    return [PasswordTool readPassWord];
}
+ (void)setLoginPwd:(NSString *)loginPwd
{
//    [self setObject:loginPwd key:kLoginPassward];
    [PasswordTool savePassWord:loginPwd];
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
    return [self returnStringWithKey:kNewFriendIdentify];
}

+ (void)setNewFriendIdentify:(NSArray *)idArr
{
    [self setObject:idArr key:kNewFriendIdentify];
}


#pragma mark - 全局设置
#pragma mark -- kThemeImage（主题图片）
+ (NSString *)getThemeImageString
{
    return [self returnStringWithKey:kThemeImage];
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


#pragma mark - private
#pragma mark -- object value
+ (void)setObject:(id)obj key:(NSString *)key
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:obj forKey:key];
    [userD synchronize];
}

+ (id)returnStringWithKey:(NSString *)key
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
