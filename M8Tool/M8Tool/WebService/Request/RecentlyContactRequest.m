//
//  RecentlyContactRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecentlyContactRequest.h"

@implementation RecentlyContactRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=nearlinkman", self.hostUrl];
}


- (NSDictionary *)packageParams
{
    return @{
             @"token" : self.token,
             @"uid" : self.uid
             };
}

- (Class)responseDataClass
{
    return [RecentlyContactResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}

@end


@implementation RecentlyContactResponseData


@end
