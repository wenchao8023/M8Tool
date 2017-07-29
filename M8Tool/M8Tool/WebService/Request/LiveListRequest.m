//
//  LiveListRequest.m
//  M8Tool
//
//  Created by looper on 17/7/22.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "LiveListRequest.h"

@implementation LiveListRequest
- (NSString *)url
{

    return [NSString stringWithFormat:@"%@svc=live&cmd=roomlist", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    if (_token.length <= 0)
    {
        return nil;
    }
    return @{
             @"token" : _token,
             @"type" : _type,
             @"index" : @(_index),
             @"size" : @(_size),
             @"appid" : @(_appid)
             };
}

- (Class)responseDataClass
{
    return [LiveListResponseData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic];
}
@end



@implementation LiveListResponseData

@end




@implementation M8LiveRoomModel


@end

@implementation M8LiveRoomInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
