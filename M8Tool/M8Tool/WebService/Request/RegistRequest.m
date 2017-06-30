//
//  RegistRequest.m
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/11/30.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "RegistRequest.h"

#import "NSObject+Json.h"

@implementation RegistRequest

- (NSString *)url
{

    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=account&cmd=regist",host];
}

- (NSDictionary *)packageParams
{
    NSDictionary *paramDic = @{@"id"  : _identifier,
                               @"pwd" : _pwd,
                               @"nick": _nick
                               };
    return paramDic;
}

//- (void)setIdPropertyValue:(id)idkeyValue
//{
//    NSNumber *value =  (NSNumber *)idkeyValue;
//    _identifier = [value integerValue];
//}


@end

