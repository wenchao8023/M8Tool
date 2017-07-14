//
//  UsrContactView+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView+Net.h"

@implementation UsrContactView (Net)


- (void)onNetLoadLocalList:(TCIVoidBlock)succHandle
{
    NSArray *selfInfoArr = @[@"我的好友", @"手机通讯录", @"常用群组", @"常用联系人"];
    [self.dataArray addObject:selfInfoArr];
    
    if (succHandle)
    {
        succHandle();
    }
}


- (void)onNetGetFriendList:(TCIVoidBlock)succHandle
{
    WCWeakSelf(self);
    FriendsListRequest *friendListReq = [[FriendsListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        FriendsListRequest *wreq = (FriendsListRequest *)request;
        FriendsListResponceData *respData = (FriendsListResponceData *)wreq.response.data;
        
        
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    friendListReq.identifier = [[ILiveLoginManager getInstance] getLoginId];
    friendListReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] AFAsynRequest:friendListReq];
}





@end
