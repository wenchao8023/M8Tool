//
//  ReportCallMemRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ReportCallMemRequest.h"

@implementation ReportCallMemRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=live&cmd=reportmemberstatu",host];
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
//                          @"statu" : @(_statu)
                          @"statu" : _statu
                          };
    return dic;
}


@end
