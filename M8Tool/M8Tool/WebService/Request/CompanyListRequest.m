//
//  CompanyListRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CompanyListRequest.h"


/**
 创建公司
 */
@implementation CompanyListRequest


- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=mycompany", self.hostUrl];
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
    return [CompanyListResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}
@end



@implementation CompanyListResponseData

@end



/**
 获取公司详情
 */
@implementation CompanyDetailRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=getcompanyinfo", self.hostUrl];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"cid"     : @(_cId)
             };
}



- (Class)responseDataClass
{
    return [CompanyDetailResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}



@end

@implementation CompanyDetailResponseData
@end
