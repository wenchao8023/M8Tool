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

+ (NSString *_Nullable)getLoginNick;
+ (void)setLoginNick:(NSString *_Nullable)loginNick;

+ (NSString *_Nullable)getLoginPwd;
+ (void)setLoginPwd:(NSString *_Nullable)loginPwd;

+ (NSString *_Nullable)getThemeImageString;
+ (void)setThemeImageString:(NSString *_Nullable)imgStr;

+ (BOOL)getUserProtocolStatu;
+ (void)setUserProtocolStatu:(BOOL)statu;
/**
 判断是否在会议中
 */
+ (BOOL)getIsInMeeting;

/**
 设置是否在会议中
 */
+ (void)setMeetingStatu:(BOOL)isInMeeting;

+ (BOOL)getPushMenuStatu;

+ (void)setPushMenuStatu:(BOOL)statu;


@end
