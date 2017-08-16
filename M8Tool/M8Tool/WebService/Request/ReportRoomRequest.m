//
//  ReportRoomRequest.m
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/12/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ReportRoomRequest.h"

#import "NSMutableDictionary+Json.h"
#import "NSObject+Json.h"

@implementation ReportRoomRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=live&cmd=reportroom",host];
}

- (NSDictionary *)packageParams
{
    if (_members && _members.count)
    {
        return @{
                    @"token"   : _token,
                    @"room"    : [_room toRoomDic],
                    @"members" : _members
                };
    }
    else
    {
        return @{
                     @"token"   : _token,
                     @"room"    : [_room toRoomDic],
                };
    }
}

- (Class)responseDataClass
{
    return [ReportRoomResponseData class];
}
@end

@implementation ReportRoomResponseData



@end


