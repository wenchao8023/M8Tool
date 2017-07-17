//
//  NSString+Common.h
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (Common)

/**
 用于获取用户简短名字
 */
- (NSString *)getSimpleName;


/**
 邮箱验证
 */
-(BOOL)validateEmail;

/**
 手机号验证
 */
-(BOOL)validateMobile;

/**
 url验证
 */
-(BOOL)validateUrl;

/**
 纯数字验证
 */
-(BOOL)validateNumText;

@end
