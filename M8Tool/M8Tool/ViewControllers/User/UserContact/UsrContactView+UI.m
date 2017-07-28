//
//  UsrContactView+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView+UI.h"
#import "UsrContactView+Net.h"

@implementation UsrContactView (UI)




- (void)loadDataInMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self reloadData];
    });
}


- (void)onDidSelectAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self performSelector:NSSelectorFromString(self.actionArray[indexPath.row]) withObject:nil afterDelay:0];
    }
    else    //选择部门
    {
        M8CompanyInfo *cInfo = self.sectionArray[indexPath.section];
        BOOL isManger = [cInfo.uid isEqualToString:[M8UserDefault getLoginId]];
        
        MangerTeamViewController *mangerVC = [[MangerTeamViewController alloc] initWithType:MangerTeamType_Partment
                                                                                  isManager:isManger
                                                                                contactType:self.contactType];
        mangerVC.isExitLeftItem = YES;
        mangerVC.dInfo = self.dataArray[indexPath.section][indexPath.row];
        [[AppDelegate sharedAppDelegate] pushViewController:mangerVC];
    }
}



/**
 我的好友
 */
- (void)onFriendListAction
{
    FriendListViewController *friendVC  = [[FriendListViewController alloc] init];
    friendVC.isExitLeftItem             = YES;
    friendVC.contactType                = self.contactType;
    [[AppDelegate sharedAppDelegate] pushViewController:friendVC];
}

/**
 手机通讯录
 */
- (void)onMobContactAction
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
- (void)onMangerComAction:(UIButton *)mangerBtn
{
    NSInteger section = mangerBtn.tag - 50;
    
    if ([mangerBtn.titleLabel.text isEqualToString:@"管理"])
    {
        WCLog(@"管理公司");
        MangerTeamViewController *mangerVC = [[MangerTeamViewController alloc] initWithType:MangerTeamType_Company
                                                                                  isManager:YES
                                                                                contactType:self.contactType];
        mangerVC.isExitLeftItem = YES;
        mangerVC.cInfo = self.sectionArray[section];
        [[AppDelegate sharedAppDelegate] pushViewController:mangerVC];
        
        
        WCWeakSelf(self);
        mangerVC.delCompanySucc = ^{
            
            [weakself onNetGetCompanyList:^{
                
                [weakself loadDataInMainThread];
            }];
        };
        
        mangerVC.updateCInfoSucc = ^(M8CompanyInfo * _Nullable cInfo) {
          
            //添加公司信息（头部分组数据）
            [weakself.sectionArray replaceObjectAtIndex:section withObject:cInfo];
            
            //添加公司部门信息（部门数组）
            NSMutableArray *tempDepartArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *departDic in cInfo.departments)
            {
                M8DepartmentInfo *departInfo = [[M8DepartmentInfo alloc] init];
                [departInfo setValuesForKeysWithDictionary:departDic];
                [tempDepartArr addObject:departInfo];
            }
            
            [weakself.dataArray replaceObjectAtIndex:section withObject:tempDepartArr];
            
            
            
            [weakself loadDataInMainThread];
        };
        
    }
    else if ([mangerBtn.titleLabel.text isEqualToString:@"邀请"])
    {
        WCLog(@"邀请好友");
        MangerTeamViewController *mangerVC = [[MangerTeamViewController alloc] initWithType:MangerTeamType_Company
                                                                                  isManager:NO
                                                                                contactType:self.contactType];
        mangerVC.isExitLeftItem = YES;
        mangerVC.cInfo = self.sectionArray[section];
        [[AppDelegate sharedAppDelegate] pushViewController:mangerVC];
    }
}

/**
 创建公司
 */
- (void)onCreateTeamAction
{
    UIAlertController *createTeamAlert = [UIAlertController alertControllerWithTitle:@"添加团队" message:nil preferredStyle:UIAlertControllerStyleAlert];
    WCWeakSelf(self);
    self.saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTF  = createTeamAlert.textFields.firstObject;
        
        [self onNetCreateTeam:nameTF.text succ:^{
            
            [weakself loadDataInMainThread];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    self.saveAction.enabled = NO;
    [createTeamAlert addAction:self.saveAction];
    [createTeamAlert addAction:cancelAction];
    
    [createTeamAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"不少于三个字";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:createTeamAlert animated:YES completion:nil];
}




- (void)alertTextFieldDidChange:(NSNotification *)notification
{
    UIAlertController *alertController = (UIAlertController *)[AppDelegate sharedAppDelegate].topViewController;
    if (alertController)
    {
        UITextField *nameTF  = alertController.textFields.firstObject;
        self.saveAction.enabled = (nameTF.text.length >= 3);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
