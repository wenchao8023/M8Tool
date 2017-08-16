//
//  MeetsCollectRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetsCollectRequest.h"

@implementation MeetsCollectRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=getmycollect", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    if (_token.length <= 0)
    {
        return nil;
    }
    return @{
             @"token" : _token,
             @"uid" : _uid,
             @"offset" : @(_offset),
             @"nums" : @(_nums)
             };
}

- (Class)responseDataClass
{
    return [MeetsListResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}


@end
