//
//  MangerTeamViewController+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController+Net.h"
#import "MangerTeamViewController+UI.h"

@implementation MangerTeamViewController (Net)

- (void)onNetloadData
{
    if (self.teamType == MangerTeamType_Partment)
    {
        [self onNetGetPartInfoWithDid:self.dInfo.did];
    }
    else
    {
        for (NSDictionary *dic in self.cInfo.departments)
        {
            [self.sectionArray addObject:[dic objectForKey:@"dname"]];
            
            [self onNetGetPartInfoWithDid:[dic objectForKey:@"did"]];
        }
    }
}

- (void)onNetGetPartInfoWithDid:(NSString *)did
{
    WCWeakSelf(self);
    PartDetailRequest *partReq = [[PartDetailRequest alloc] initWithHandler:^(BaseRequest *request) {
     
        PartDetailResponseData *respData = (PartDetailResponseData *)request.response.data;
        
        [weakself loadMembersArray:respData.members];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    partReq.token = [AppDelegate sharedAppDelegate].token;
    partReq.did   = [did intValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:partReq];
}

- (void)loadMembersArray:(NSArray *)membersArr
{
    NSMutableArray *tempMemArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in membersArr)
    {
        M8MemberInfo *info = [M8MemberInfo new];
        [info setValuesForKeysWithDictionary:dic];
        [tempMemArr addObject:info];
    }
    [self.itemArray addObject:tempMemArr];
    
    [self onReloadDataInMainThread];
}



@end
