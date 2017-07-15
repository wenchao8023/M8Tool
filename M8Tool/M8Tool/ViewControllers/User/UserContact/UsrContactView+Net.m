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


- (void)onNetGetCompanyList:(TCIVoidBlock)succHandle
{
    WCWeakSelf(self);
    CompanyListRequest *cListReq = [[CompanyListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        CompanyListRequest *wreq = (CompanyListRequest *)request;
        CompanyListResponseData *respData = (CompanyListResponseData *)wreq.response.data;
        
        for (NSDictionary *dic in respData.companys)
        {
            //添加公司信息（头部分组数据）
            M8CompanyInfo *info = [[M8CompanyInfo alloc] init];
            [info setValuesForKeysWithDictionary:dic];
            [weakself.sectionArray addObject:info];
            
            //添加公司部门信息（部门数组）
            NSMutableArray *tempDepartArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *departDic in info.departments)
            {
                M8DepartmentInfo *departInfo = [[M8DepartmentInfo alloc] init];
                [departInfo setValuesForKeysWithDictionary:departDic];
                [tempDepartArr addObject:departInfo];
            }
            [weakself.dataArray addObject:tempDepartArr];
        }

        [weakself configStatuArray];
//        weakself.statuArray = nil;
//        [weakself statuArray];
        
        if (succHandle)
        {
            succHandle();
        }
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    cListReq.uid = [[ILiveLoginManager getInstance] getLoginId];
    cListReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] AFAsynRequest:cListReq];
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
