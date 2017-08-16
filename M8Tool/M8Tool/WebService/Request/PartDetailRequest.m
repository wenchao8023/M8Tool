//
//  PartDetailRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "PartDetailRequest.h"

@implementation PartDetailRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=getdepartmentmembers", self.hostUrl];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"did"     : @(_did)
             };
}

- (Class)responseDataClass
{
    return [PartDetailResponseData class];
}



@end

@implementation PartDetailResponseData

@end
