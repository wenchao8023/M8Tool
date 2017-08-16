//
//  ModifyPwdRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ModifyPwdRequest.h"

@implementation ModifyPwdRequest

@end


@implementation ModifyPwdWithOldPwdRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=verifyupdatepwd", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token" : _token,
             @"id"    : _uid,
             @"oldpwd": _oldpwd,
             @"pwd"   : _pwd
             };
}

@end


@implementation ModifyPwdWithPhoneRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=updatepwd", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"phoneNumber" : _phoneNumber,
             @"messageCode" : _messageCode,
             @"pwd"         : _pwd
             };
}

@end
