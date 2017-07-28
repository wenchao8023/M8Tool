//
//  FriendsRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "FriendsRequest.h"

@implementation FriendsRequest

@end
//====================================

/**************************************
 ****            添加好友           ****
 **************************************/
@implementation M8AddFriendRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=addFriend", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"id"      : _uid,
             @"frd_id"  : _frd_id
             };
}

@end




/**************************************
 ****            删除好友           ****
 **************************************/
@implementation M8DeleteFriendRequest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=deleteFriend", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    return @{
             @"id"      : _uid,
             @"frd_id"  : _frd_id
             };
}

@end





/**************************************
 ****          获取好友列表          ****
 **************************************/
@implementation FriendsListRequest

- (NSString *)url {
    return [NSString stringWithFormat:@"%@svc=account&cmd=getAllFriends", [self hostUrl]];
}

- (NSDictionary *)packageParams
{
    NSDictionary *paramDic = @{
                               @"token"  : _token,
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
    return [NSObject parse:[self responseDataClass] dictionary:dataDic itemClass:[M8FriendInfo class]];
}
@end


@implementation FriendsListResponceData


@end



