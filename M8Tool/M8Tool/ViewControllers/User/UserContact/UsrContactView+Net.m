//
//  UsrContactView+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView+Net.h"

@implementation UsrContactView (Net)


- (void)onNetLoadLocalList:(M8VoidBlock)succHandle
{
    NSArray *selfInfoArr = @[@"我的好友", @"手机通讯录"];
    [self.dataArray addObject:selfInfoArr];
    
    if (succHandle)
    {
        succHandle();
    }
}


- (void)onNetGetCompanyList:(M8VoidBlock)succHandle
{
    WCWeakSelf(self);
    CompanyListRequest *cListReq = [[CompanyListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        CompanyListRequest *wreq = (CompanyListRequest *)request;
        CompanyListResponseData *respData = (CompanyListResponseData *)wreq.response.data;
        
        //移除数组中原有的（第一个分组中的除外） -- 删除的时候要从后往前删
        while (self.sectionArray.count > 1)     //确保跳过第一个元素
        {
            [self.sectionArray  removeObjectAtIndex:1];     //每次删除第二个元素
            [self.dataArray     removeObjectAtIndex:1];
        }

        
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

        
        if (succHandle)
        {
            succHandle();
        }
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    cListReq.uid = [M8UserDefault getLoginId];
    cListReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] AFAsynRequest:cListReq];
}

// 创建公司
- (void)onNetCreateTeam:(NSString *)teamName succ:(M8VoidBlock)succHandle
{
    WCWeakSelf(self);
    CreateCompanyRequest *createTeamReq = [[CreateCompanyRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        NSString *cid = ((CreateCompanyResponseData *)request.response.data).cid;
        [weakself onNetCreateDefaultPart:cid succ:succHandle];
        
    } failHandler:^(BaseRequest *request) {
        
        if (request.response.errorCode ==  10086)
        {
            [AlertHelp tipWith:@"公司已存在，请确认是否输入正确！" wait:1];
        }
    }];
    
    createTeamReq.token = [AppDelegate sharedAppDelegate].token;
    createTeamReq.uid   = [M8UserDefault getLoginId];
    createTeamReq.name  = teamName;
    [[WebServiceEngine sharedEngine] AFAsynRequest:createTeamReq];
}

//创建默认分组
- (void)onNetCreateDefaultPart:(NSString *)cid succ:(M8VoidBlock)succHandle
{
    WCWeakSelf(self);
    int myCid = [cid intValue];
    CreatePartRequest *createPartReq = [[CreatePartRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        NSString *did = ((CreatePartResponseData *)request.response.data).did;
        [weakself onNetJoinSelfToDefaultPart:did succ:succHandle];
        
    } failHandler:^(BaseRequest *request) {
        
        //如果该默认分组存在, 那么就直接将自己加入该分组
        if (request.response.errorCode ==  10086)
        {
            [AlertHelp tipWith:@"部门已存在!" wait:1];
        }
    }];
    
    createPartReq.token = [AppDelegate sharedAppDelegate].token;
    createPartReq.uid   = [M8UserDefault getLoginId];
    createPartReq.cid   = myCid;
    createPartReq.name  = @"组织架构";
    [[WebServiceEngine sharedEngine] AFAsynRequest:createPartReq];
}

//将自己加入默认分组
- (void)onNetJoinSelfToDefaultPart:(NSString *)did succ:(M8VoidBlock)succHandle
{
    WCWeakSelf(self);
    int myDid = [did intValue];
    JoinPartRequest *joinPartReq = [[JoinPartRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        weakself.clickSection = -1;
        
        [weakself onNetGetCompanyList:succHandle];
        
    } failHandler:^(BaseRequest *request) {
        
        //加入失败，再次加入
        if (!(request.response.errorCode == 0 ||
            request.response.errorCode == 10086))
        {
            [weakself onNetJoinSelfToDefaultPart:did succ:succHandle];
        }
    }];
    
    joinPartReq.token = [AppDelegate sharedAppDelegate].token;
    joinPartReq.uid   = @[[M8UserDefault getLoginId]];
    joinPartReq.did   = myDid;
    [[WebServiceEngine sharedEngine] AFAsynRequest:joinPartReq];
}


- (void)onNetDeleteDepartmentForIndexPath:(NSIndexPath *)indexPath succ:(M8VoidBlock _Nullable)succHandle
{
    M8DepartmentInfo *dInfo = self.dataArray[indexPath.section][indexPath.row];
    DeleteDepartmentReuqest *delDReq = [[DeleteDepartmentReuqest alloc] initWithHandler:^(BaseRequest *request) {
        
        if (succHandle)
        {
            succHandle();
        }
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    delDReq.token = [AppDelegate sharedAppDelegate].token;
    delDReq.uid   = [M8UserDefault getLoginId];
    delDReq.did   = [dInfo.did intValue];
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:delDReq];
}

@end
