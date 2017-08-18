//
//  SendNotifyRequest.m
//  M8Tool
//
//  Created by chao on 2017/8/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "SendNotifyRequest.h"

@implementation SendNotifyRequest

@end

@implementation SendCallNotifyRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc = xinge&cmd=pushAccountIos", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token" :     _token,
             @"inviter" :   _inviter,
             @"type" :      @(_type),
             @"topic" :     @(_topic),
             @"toUser" :    _toUser
             };
}
@end
