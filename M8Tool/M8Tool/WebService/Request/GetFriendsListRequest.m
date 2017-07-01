//
//  GetFriendsListRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "GetFriendsListRequest.h"

@implementation GetFriendsListRequest

- (NSString *)url {
    return [NSString stringWithFormat:@"%@svc=account&cmd=getAllFriends", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    NSDictionary *paramDic = @{@"token"  : _token,
                               @"id" : _identifier,
                               };
    return paramDic;
}

- (Class)responseDataClass
{
    return [GetFriendsListResponceData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic itemClass:[M8IMModels class]];
}
@end


@implementation GetFriendsListResponceData


@end
