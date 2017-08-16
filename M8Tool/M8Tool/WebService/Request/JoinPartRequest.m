//
//  JoinPartRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "JoinPartRequest.h"

@implementation JoinPartRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=adddepartment", self.hostUrl];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"uid"     : _uid,
             @"did"     : @(_did)
             };
}
@end
