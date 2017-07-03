//
//  FriendsListRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "FriendsListRequest.h"

@implementation FriendsListRequest

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
    return [FriendsListResponceData class];
}

- (BaseResponseData *)parseResponseData:(NSDictionary *)dataDic
{
    return [NSObject parse:[self responseDataClass] dictionary:dataDic itemClass:[M8IMModels class]];
}
@end


@implementation FriendsListResponceData


@end
