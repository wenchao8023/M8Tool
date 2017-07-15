//
//  UsrContactView+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView+UI.h"

@implementation UsrContactView (UI)

- (void)loadDataInMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self reloadData];
    });
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self performSelector:NSSelectorFromString(self.actionArray[indexPath.row]) withObject:nil afterDelay:0];
    }
}



/**
 我的好友
 */
- (void)onFriendListAction
{
    FriendListViewController *friendVC = [[FriendListViewController alloc] init];
    friendVC.isExitLeftItem = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:friendVC];
}

/**
 手机通讯录
 */
- (void)onMobContactAction
{
    
}

/**
 常用群组
 */
- (void)onCommonGroupAction
{
    
}

/**
 常用联系人
 */
- (void)onCommonContactAction
{
    
}

/**
 头部分组事件
 */
- (void)onHeaderAction:(UITapGestureRecognizer *)tap
{
    UIView *headView = tap.view;
    
    self.clickSection = headView.tag - 10;
    
    [self configStatuArray];
    
    [self loadDataInMainThread];
}

/**
 头部按钮事件
 */
- (void)onMangerComAction
{
    WCLog(@"管理公司");
}

/**
 最后一个头部分组创建公司
 */
- (void)onCreateTeamAction
{
    CreateCompanyViewController *createCVC = [[CreateCompanyViewController alloc] init];
    createCVC.isExitLeftItem = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:createCVC];
}


@end
