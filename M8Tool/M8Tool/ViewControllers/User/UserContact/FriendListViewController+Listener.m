//
//  FriendListViewController+Listener.m
//  M8Tool
//
//  Created by chao on 2017/7/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "FriendListViewController+Listener.h"

@implementation FriendListViewController (Listener)

- (void)OnProxyStatusChange:(TIM_FRIENDSHIP_PROXY_STATUS)status
{
    WCLog(@"OnProxyStatusChange");
}


- (void)OnAddFriends:(NSArray *)users
{
    WCLog(@"OnAddFriends");
}


- (void)OnDelFriends:(NSArray *)identifiers
{
    WCLog(@"OnDelFriends");
}

- (void)OnAddFriendReqs:(NSArray *)reqs
{
    WCLog(@"OnAddFriendReqs");
}

@end
