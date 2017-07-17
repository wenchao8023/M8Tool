//
//  CreateCompanyRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CreateCompanyRequest.h"

@implementation CreateCompanyRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=createcompany", self.hostUrl];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"uid"     : _uid,
             @"name"    : _name
             };
}

- (Class)responseDataClass
{
    return [CreateCompanyResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}

@end


@implementation CreateCompanyResponseData


@end
