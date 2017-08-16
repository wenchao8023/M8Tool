//
//  PasswordTool.h
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordTool : NSObject

/**
 *    @brief    存储密码
 *
 *    @param     password     密码内容
 */
+(void)savePassWord:(NSString *)password;

/**
 *    @brief    读取密码
 *
 *    @return    密码内容
 */
+(id)readPassWord;

/**
 *    @brief    删除密码数据
 */
+(void)deletePassWord;



/**
 *    @brief    存储QQ openId
 *
 *    @param     openId openId
 */
+(void)saveQQOpenId:(NSString *)openId;

/**
 *    @brief    读取QQ openId
 *
 *    @return    密码内容
 */
+(id)readQQOpenId;

/**
 *    @brief    删除密码数据
 */
+(void)deleteQQOpenId;


@end
