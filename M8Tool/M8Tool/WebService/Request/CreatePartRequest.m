//
//  CreatePartRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CreatePartRequest.h"

@implementation CreatePartRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=createdepartment", self.hostUrl];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"uid"     : _uid,
             @"cid"     : @(_cid),
             @"name"    : _name
             };
}

- (Class)responseDataClass
{
    return [CreatePartResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}


@end


@implementation CreatePartResponseData


@end
