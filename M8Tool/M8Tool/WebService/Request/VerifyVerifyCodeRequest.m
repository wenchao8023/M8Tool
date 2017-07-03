//
//  VerifyVerifyCodeRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/3.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "VerifyVerifyCodeRequest.h"

@implementation VerifyVerifyCodeRequest

- (NSString *)url
{
    
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=account&cmd=verifyMessage",host];
}

- (NSDictionary *)packageParams
{
    return @{@"phoneNumber" : _phoneNumber,
             @"messageCode" : _messageCode
             };
}

@end
