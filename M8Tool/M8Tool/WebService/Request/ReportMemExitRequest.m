//
//  ReportMemExitRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ReportMemExitRequest.h"

@implementation ReportMemExitRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=account&cmd=reportexitcall",host];
}

- (NSDictionary *)packageParams
{
    if (_token == nil || _uid == nil)
    {
        NSString *info = [NSString stringWithFormat:@"token=%@,userid=%@,fun=%s",_token,_uid,__func__];
        [[ILiveSDK getInstance] iLivelog:ILive_LOG_DEBUG tag:@"TILLiveSDKShow" msg:info];
        return nil;
    }
    NSDictionary *dic = @{@"token" : _token,
                          @"uid" : _uid,
                          @"mid" :  @(_mid),
                          };
    return dic;
}

@end
