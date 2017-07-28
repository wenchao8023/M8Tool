//
//  MangerTeamViewController+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController+Net.h"
#import "MangerTeamViewController+UI.h"

//获取部门详情接口需要修改
//返回信息携带部门名或者是部门ID
@implementation MangerTeamViewController (Net)

- (void)onNetloadData
{
    [self.sectionArray  removeAllObjects];
    [self.itemArray     removeAllObjects];
    
    if (self.teamType == MangerTeamType_Partment)
    {
        [self onNetGetPartInfoWithDid:self.dInfo.did];
    }
    else
    {
        for (NSDictionary *dic in self.cInfo.departments)
        {
            [self.sectionArray addObject:[dic objectForKey:@"dname"]];
            [self.itemArray    addObject:@[]];
            
            [self onNetGetPartInfoWithDid:[dic objectForKey:@"did"]];
        }
    }
}

- (void)onNetGetPartInfoWithDid:(NSString *)did
{
    WCWeakSelf(self);
    PartDetailRequest *partReq = [[PartDetailRequest alloc] initWithHandler:^(BaseRequest *request) {
     
        PartDetailResponseData *respData = (PartDetailResponseData *)request.response.data;
        
        [weakself loadMembersArray:respData];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    partReq.token = [AppDelegate sharedAppDelegate].token;
    partReq.did   = [did intValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:partReq];
}

- (void)loadMembersArray:(PartDetailResponseData *)respData
{
    NSArray *membersArr = respData.members;
    
    NSMutableArray *tempMemArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in membersArr)
    {
        M8MemberInfo *info = [M8MemberInfo new];
        [info setValuesForKeysWithDictionary:dic];
        [tempMemArr addObject:info];
    }
    
    if (self.teamType == MangerTeamType_Partment)
    {
        [self.itemArray addObject:tempMemArr];
    }
    else
    {
        NSDictionary *dInfo = respData.department;
        NSString *dname = [dInfo objectForKey:@"dname"];

        if ([self.sectionArray containsObject:dname])
        {
            NSInteger index = [self.sectionArray indexOfObject:dname];
            [self.itemArray replaceObjectAtIndex:index withObject:tempMemArr];
        }
    }
    
    [self onReloadDataInMainThread];
}

- (void)onNetDeleteCompany
{
    WCWeakSelf(self);
    DeleteCompanyReuqest *delCompanyReq = [[DeleteCompanyReuqest alloc] initWithHandler:^(BaseRequest *request) {
        
        if (weakself.delCompanySucc)
        {
            weakself.delCompanySucc();
        }
        
        [weakself.navigationController popViewControllerAnimated:YES];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    delCompanyReq.token = [AppDelegate sharedAppDelegate].token;
    delCompanyReq.uid   = [M8UserDefault getLoginId];
    delCompanyReq.cid   = [self.cInfo.cid intValue];
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:delCompanyReq];
}


- (void)onNetCreateDepartment:(NSString *)partName
{
    WCWeakSelf(self);
    CreatePartRequest *partReq = [[CreatePartRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        [weakself onNetGetCompanyDetail];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    partReq.token = [AppDelegate sharedAppDelegate].token;
    partReq.uid   = [M8UserDefault getLoginId];
    partReq.cid   = [self.cInfo.cid intValue];
    partReq.name  = partName;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:partReq];
}



- (void)onNetGetCompanyDetail
{
    WCWeakSelf(self);
    CompanyDetailRequest *detailReq = [[CompanyDetailRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        CompanyDetailResponseData *detailResponseData = (CompanyDetailResponseData *)request.response.data;
        
        M8CompanyInfo *cInfo = [[M8CompanyInfo alloc] init];
        [cInfo setValuesForKeysWithDictionary:detailResponseData.companyinfo];
        
        if (detailResponseData)
        {
            weakself.cInfo = cInfo;
            
            if (weakself.updateCInfoSucc)
            {
                weakself.updateCInfoSucc(cInfo);
            }
            
            [weakself onNetloadData];
        }
        
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    detailReq.token = [AppDelegate sharedAppDelegate].token;
    detailReq.cId   = [self.cInfo.cid intValue];
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:detailReq];
}



//添加单个成员进部门
- (void)onNetJoinMember:(NSString *)memberId toPart:(NSString *)did succ:(M8VoidBlock)succHandle
{
    WCWeakSelf(self);
    
    JoinPartRequest *joinPartReq = [[JoinPartRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        if (succHandle)
        {
            succHandle();
        }
        
         [self onNetloadData];
        
    } failHandler:^(BaseRequest *request) {
        
        //加入失败，再次加入
        if (!(request.response.errorCode == 0 ||
              request.response.errorCode == 10086))
        {
            [weakself onNetJoinMember:memberId toPart:did succ:succHandle];
        }
    }];
    
    joinPartReq.token = [AppDelegate sharedAppDelegate].token;
    joinPartReq.uid   = @[memberId];
    joinPartReq.did   = [did intValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:joinPartReq];
}


@end
