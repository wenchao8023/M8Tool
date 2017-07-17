//
//  MangerTeamViewController+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController+UI.h"

@implementation MangerTeamViewController (UI)

- (void)onReloadDataInMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
    });
}

- (void)onDidSelectAtIndex:(NSIndexPath *)indexPath
{

}


/**
 头部分组事件
 */
- (void)onHeaderViewAction:(UITapGestureRecognizer *)tap
{
//    UIView *headView = tap.view;
//    
//    self.clickSection = headView.tag - 10;
//    
//    [self configStatuArray];
//    
//    [self loadDataInMainThread];
}

- (void)onAddMemberAction
{
    
}

- (void)onShareAction
{
    
}

- (void)onAddAction
{
    if (self.isManger)
    {
        if (self.teamType == MangerTeamType_Company)
        {
            WCLog(@"添加部门");
        }
        else if (self.teamType == MangerTeamType_Partment)
        {
            WCLog(@"添加员工");
        }
    }
    
    if (self.contactType == ContactType_sel)
    {
        WCLog(@"选择成员添加");
    }
}
@end
