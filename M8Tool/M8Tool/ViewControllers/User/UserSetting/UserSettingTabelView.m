//
//  UserSettingTabelView.m
//  M8Tool
//
//  Created by chao on 2017/5/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserSettingTabelView.h"

#import "SettingPwdViewController.h"


@interface UserSettingTabelView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *actionsArray;

@end

@implementation UserSettingTabelView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView    = [WCUIKitControl createViewWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.tableHeaderView    = [WCUIKitControl createViewWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.dataSource         = self;
        self.delegate           = self;
        self.scrollEnabled      = NO;
        self.backgroundColor    = WCClear;
        
    }
    return self;
}

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        NSArray *dataArrray = @[@[@"密码设置", @"新消息设置", @"关于iBuild"],
                                @[@"退出"]];
        _dataArray = dataArrray;
    }
    return _dataArray;
}

- (NSArray *)actionsArray
{
    if (!_actionsArray)
    {
        _actionsArray = @[@[@"onPwdSetAction", @"onNewMsgSetAction", @"onAboutAction"],
                          @[@"onLogoutAction"]];
    }
    return _actionsArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UserSettingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WCClear;
        [cell.textLabel setAttributedText:[CommonUtil customAttString:self.dataArray[indexPath.section][indexPath.row]
                                                             fontSize:kAppLargeFontSize
                                                            textColor:WCBlack
                                                            charSpace:kAppKern_4]
         ];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [WCUIKitControl createViewWithFrame:CGRectMake(0, 0, self.width, 0.01)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [WCUIKitControl createViewWithFrame:CGRectMake(0, 0, self.width, 0.01)];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:NSSelectorFromString(self.actionsArray[indexPath.section][indexPath.row]) withObject:indexPath afterDelay:0];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - actions
- (void)onPwdSetAction
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"为保障你的数据安全，修改密码前请填写原密码。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction     = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *pwdTF = alertC.textFields.firstObject;
        
        if ([pwdTF.text isEqualToString:[M8UserDefault getLoginPwd]])
        {
            // verify ok
            SettingPwdViewController *spvc = [[SettingPwdViewController alloc] init];
            spvc.isExitLeftItem = YES;
            [[AppDelegate sharedAppDelegate] pushViewController:spvc];
        }
        else
        {
            [AlertHelp tipWith:@"输入密码错误" wait:1];
        }
    }];
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        textField.secureTextEntry = YES;
    }];
    
    [alertC addAction:cancelAction];
    [alertC addAction:okAction];
    
    [[[AppDelegate sharedAppDelegate] topViewController] presentViewController:alertC animated:YES completion:nil];
}

- (void)onNewMsgSetAction
{
    
}

- (void)onAboutAction
{
    
}

- (void)onLogoutAction
{
    if ([CommonUtil alertTipInMeeting])
    {
        return ;
    }
    
    LoadView *logoutWaitView = [LoadView loadViewWith:@"正在退出"];
    [self addSubview:logoutWaitView];
    
    //通知业务服务器登出
    LogoutRequest *logoutReq = [[LogoutRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        [[ILiveLoginManager getInstance] iLiveLogout:^{
            
            [logoutWaitView removeFromSuperview];

            [M8UserDefault setUserLogout:YES];
            
            [[AppDelegate sharedAppDelegate] enterLoginUI];
            
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            
            [logoutWaitView removeFromSuperview];
            NSString *errinfo = [NSString stringWithFormat:@"module=%@,errid=%ld,errmsg=%@",module,(long)request.response.errorCode,request.response.errorInfo];
            NSLog(@"regist fail.%@",errinfo);
            [AlertHelp alertWith:@"退出失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        }];
        
    } failHandler:^(BaseRequest *request) {
        
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        NSLog(@"regist fail.%@",errinfo);
        [logoutWaitView removeFromSuperview];
        [AlertHelp alertWith:@"退出失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
    }];
    
    logoutReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] AFAsynRequest:logoutReq];
}


@end
