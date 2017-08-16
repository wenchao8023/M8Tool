//
//  PasswordTool.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "PasswordTool.h"
#import "KeychainTool.h"

@implementation PasswordTool

static NSString * const KEY_IN_KEYCHAIN_PWD         = @"com.ibuildtek.M8Tool.chaoge.keychain.password";
static NSString * const KEY_PASSWORD                = @"com.ibuildtek.M8Tool.chaoge.key.password";

static NSString * const KEY_IN_KEYCHAIN_QQOPENID    = @"com.ibuildtek.M8Tool.chaoge.keychain.QQopenid";
static NSString * const KEY_QQOPENID                = @"com.ibuildtek.M8Tool.chaoge.key.QQopenid";


+(void)savePassWord:(NSString *)password
{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [KeychainTool save:KEY_IN_KEYCHAIN_PWD data:usernamepasswordKVPairs];
}

+(id)readPassWord
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[KeychainTool load:KEY_IN_KEYCHAIN_PWD];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}

+(void)deletePassWord
{
    [KeychainTool delete:KEY_IN_KEYCHAIN_PWD];
}



+ (void)saveQQOpenId:(NSString *)openId
{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:openId forKey:KEY_QQOPENID];
    [KeychainTool save:KEY_IN_KEYCHAIN_QQOPENID data:usernamepasswordKVPairs];
}

+(id)readQQOpenId
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[KeychainTool load:KEY_IN_KEYCHAIN_QQOPENID];
    return [usernamepasswordKVPair objectForKey:KEY_QQOPENID];
}

+(void)deleteQQOpenId
{
    [KeychainTool delete:KEY_IN_KEYCHAIN_QQOPENID];
}


@end
