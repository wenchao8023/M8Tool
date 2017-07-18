//
//  MeetCollectRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetCollectRequest.h"

@implementation MeetCollectRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=collectmeet", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"token" : _token,
             @"uid" : _uid,
             @"mid" : @(_mid)
             };
}

@end
