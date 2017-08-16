//
//  MangerTeamViewController+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController+UI.h"
#import "MeetingLuanchViewController.h"
#import "MangerTeamViewController+Net.h"


@implementation MangerTeamViewController (UI)

- (void)onReloadDataInMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
    });
}

- (void)onDeleteCompanyAction
{
    [AlertHelp alertWith:nil message:@"请确实是否删除该团队" cancelAction:nil okAction:^(UIAlertAction * _Nonnull action) {
        
        [self onNetDeleteCompany];
    }];
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
            
            NSInteger selectNum = modelManger.selectMemberArray.count;
            
            NSString *buttonStr = nil;
            if (selectNum)
            {
                buttonStr = [NSString stringWithFormat:@"选择(%ld)人", (long)selectNum];
            }
            else
            {
                buttonStr = @"选择";
            }
            self.addButton.enabled = (selectNum > 0);
            
            [UIView setAnimationsEnabled:NO];
            [self.addButton setAttributedTitle:[CommonUtil
                                                customAttString:buttonStr
                                                fontSize:kAppMiddleFontSize
                                                textColor:WCWhite
                                                charSpace:kAppKern_2]
                                      forState:UIControlStateNormal];
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
//                [AlertHelp tipWith:@"你点啥, 再点一个试试" wait:1];
            }
        }
            break;
        case ContactType_invite:    //邀请成员
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger onSelectAtMemberInfo:self.itemArray[indexPath.section][indexPath.row]];
            
            [self onReloadDataInMainThread];
            
            NSInteger selectNum = modelManger.selectMemberArray.count;
            
            NSString *buttonStr = nil;
            if (selectNum)
            {
                buttonStr = [NSString stringWithFormat:@"邀请(%ld)人", (long)selectNum];
            }
            else
            {
                buttonStr = @"邀请";
            }
            self.addButton.enabled = (selectNum > 0);
            
            [UIView setAnimationsEnabled:NO];
            [self.addButton setAttributedTitle:[CommonUtil
                                                customAttString:buttonStr
                                                fontSize:kAppMiddleFontSize
                                                textColor:WCWhite charSpace:kAppKern_2]
                                      forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
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
    
}

- (void)onAddMemberAction:(UIButton *)btn
{
    //点击分组的下标
    NSInteger index = btn.tag - 210;
    
    [self onAddMemberActionInMangerCompany:index];
}

//底部按钮
- (void)onShareAction
{
    
    
    UIImage *testImg = [UIImage imageNamed:@"jinshenku"];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:testImg
                                        url:[NSURL URLWithString:@"http://ibuildtek.com"]
                                      title:@"木木是傻嗨"
                                       type:SSDKContentTypeAuto];
    //有的平台要客户端分享需要加此方法，例如微博
    [shareParams SSDKEnableUseClientShare];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
    }];
}

- (void)onAddAction
{
    if (self.contactType == ContactType_sel)
    {
        WCLog(@"选择成员添加");

        NSArray *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count > 3)
        {
            UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count - 3];
            if ([vc isKindOfClass:[MeetingLuanchViewController class]])
            {
                MeetingLuanchViewController *luanchVC = (MeetingLuanchViewController *)vc;
                luanchVC.isBackFromSelectContact = YES;
                [self.navigationController popToViewController:luanchVC animated:YES];
            }
            
        }
        
    }
    else if (self.contactType == ContactType_invite)
    {
        self.isInviteBack = YES;
        
        [WCNotificationCenter postNotificationName:kInviteMembers_Notifycation object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (self.isManger)
        {
            if (self.teamType == MangerTeamType_Company)
            {
                WCLog(@"添加部门");
                [self onAddPartAction];
            }
            else if (self.teamType == MangerTeamType_Partment)
            {
                WCLog(@"添加员工");
                [self onAddMemberActionInMangerDepartmemt];
            }
        }
    }
}

- (void)onAddPartAction
{
    UIAlertController *addPartAlert = [UIAlertController alertControllerWithTitle:@"添加部门" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    WCWeakSelf(self);
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTF  = addPartAlert.textFields.firstObject;
        if (nameTF.text.length < 3)
        {
            [AlertHelp tipWith:@"请输入正确的部门名" wait:1];
            return ;
        }
        
        [weakself onNetCreateDepartment:nameTF.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [addPartAlert addAction:okAction];
    [addPartAlert addAction:cancelAction];
    
    [addPartAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"不少于三个字";
    }];
    
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:addPartAlert animated:YES completion:nil];
}


/**
 点击底部的添加成员按钮进行添加
 */
- (void)onAddMemberActionInMangerDepartmemt
{
    UIAlertController *addPartAlert = [UIAlertController alertControllerWithTitle:@"添加成员" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    WCWeakSelf(self);
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UITextField *phoneTF  = addPartAlert.textFields.lastObject;
        //        if ([phoneTF.text validateMobile])
        //        {
        //            [AlertHelp tipWith:@"请输入正确的手机号" wait:1];
        //
        //            return ;
        //        }
        
                [weakself onNetJoinMember:phoneTF.text toPart:weakself.dInfo.did succ:nil];
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [addPartAlert addAction:okAction];
    [addPartAlert addAction:cancelAction];
    
    [addPartAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"手机号";
    }];
    
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:addPartAlert animated:YES completion:nil];
}


/**
 点击头部分组视图添加成员进行添加
 */
- (void)onAddMemberActionInMangerCompany:(NSInteger)index
{
    UIAlertController *addPartAlert = [UIAlertController alertControllerWithTitle:@"添加成员" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *phoneTF  = addPartAlert.textFields.lastObject;
//        if ([phoneTF.text validateMobile])
//        {
//            [AlertHelp tipWith:@"请输入正确的手机号" wait:1];
//            
//            return ;
//        }
        
        NSArray *partArr = self.cInfo.departments;
        
        if (index < partArr.count)
        {
            NSDictionary *partDic = partArr[index];
            NSString *partid = [partDic objectForKey:@"did"];
            [self onNetJoinMember:phoneTF.text toPart:partid succ:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [addPartAlert addAction:okAction];
    [addPartAlert addAction:cancelAction];
    
    [addPartAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"手机号";
    }];
    
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:addPartAlert animated:YES completion:nil];
}

@end
