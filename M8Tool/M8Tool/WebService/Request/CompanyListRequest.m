//
//  CompanyListRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CompanyListRequest.h"

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
