//
//  VerifyCodeRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/3.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "VerifyCodeRequest.h"


@implementation VerifyCodeRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=account&cmd=sendMessage",host];
}

- (NSDictionary *)packageParams
{
    return @{
             @"phoneNumber"  : _phoneNumber
             };
}


@end
