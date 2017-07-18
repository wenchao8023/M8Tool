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
    switch (self.contactType)
    {
        case ContactType_sel:       //选人
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger onSelectAtMemberInfo:self.itemArray[indexPath.section][indexPath.row]];
            
            [self onReloadDataInMainThread];
            
            NSString *buttonStr = self.addButton.titleLabel.text;
            [UIView setAnimationsEnabled:NO];
            [self.addButton setTitle:[NSString stringWithFormat:@"%@(%ld)人", buttonStr, modelManger.selectMemberArray.count] forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
        }
            break;
        case ContactType_tel:       //电话
        {
            M8MemberInfo *info = self.itemArray[indexPath.section][indexPath.row];
            [CommonUtil makePhone:info.uid];
        }
            break;
        case ContactType_contact:   //通讯录
        {
            if (self.isManger)
            {
                [AlertHelp tipWith:@"你点啥, 再点一个试试" wait:1];
            }
        }
            break;
        case ContactType_invite:    //邀请成员
        {
            
        }
            break;
        default:
            break;
    }
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
