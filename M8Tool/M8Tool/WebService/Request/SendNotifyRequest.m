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




@implementation MakeCallNotifyRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=xinge&cmd=makeCallPush", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"notifyType" :  @(_notifyType),
             @"callType" :    @(_callType),
             @"token" :       _token,
             @"inviter" :     _inviter,
             @"toUser" :      _toUser
             };
}

@end
