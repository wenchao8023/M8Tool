//
//  LoginRequest.m
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/11/30.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=account&cmd=login",host];
}

- (NSDictionary *)packageParams
{
    NSDictionary *paramDic = @{@"id"  : _identifier,
                               @"pwd" : _pwd
                               };
    return paramDic;
}

- (Class)responseDataClass
{
    return [LoginResponceData class];
}

@end

@implementation LoginResponceData

@end



@implementation QQLoginRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=account&cmd=qqlogin",host];
}

- (NSDictionary *)packageParams
{
    NSDictionary *paramDic = @{
                               @"id"    : _openId,
                               @"nick"  : _nick,
                               @"appid" : _appId
                               };
    return paramDic;
}

- (Class)responseDataClass
{
    return [LoginResponceData class];
}


@end
