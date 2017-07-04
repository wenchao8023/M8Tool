//
//  CallRoomRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CallRoomRequest.h"

@implementation CallRoomRequest

- (NSString *)url

{
    return [NSString stringWithFormat:@"%@svc=live&cmd=getCallRoom", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{@"token" : _token,
             @"state" : @"ok"
             };
}

- (Class)responseDataClass
{
    return [CallRoomResponseData class];
}

@end


@implementation CallRoomResponseData


@end
