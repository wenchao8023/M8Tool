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

/**
 判断是否在会议中
 */
+ (BOOL)getIsInMeeting;

/**
 设置是否在会议中
 */
+ (void)setMeetingStatu:(BOOL)isInMeeting;

@end
