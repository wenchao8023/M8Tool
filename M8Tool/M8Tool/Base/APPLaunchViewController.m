//
//  APPLaunchViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "APPLaunchViewController.h"

#import "M8LoginWebService.h"

@interface APPLaunchViewController ()

@end

@implementation APPLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [WCNotificationCenter addObserver:self selector:@selector(netUnable) name:kAppLaunchingNet_Notification object:nil];
    
    [self autoLogin];
}

- (void)netUnable
{
    //网络异常
    if (![AppDelegate sharedAppDelegate].netEnable)
    {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        
        [AlertHelp tipWith:@"网络连接异常" wait:1];
        
        return ;
    }
}

- (void)autoLogin
{
    //app 首次启动
    if (![M8UserDefault getUserProtocolStatu])
    {
        [[AppDelegate sharedAppDelegate] enterLoginMutiUI];
        
        return ;
    }
    
    //用户主动登出
    if ([M8UserDefault getIsUserLogout])
    {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
        
        return ;
    }
    
    LastLoginType loginType = [M8UserDefault getLastLoginType];
    M8LoginWebService *loginWeb = [[M8LoginWebService alloc] init];
    
    if (loginType == LastLoginType_QQ)
    {
        NSString *openid = [M8UserDefault getLoginId];
        NSString *nick   = [M8UserDefault getLoginNick];
        
        [loginWeb M8QQAutoLoginWithOpenId:openid nick:nick failHandle:^{
            
            [[AppDelegate sharedAppDelegate] enterLoginUI];
        }];
        
    }
    else if (loginType == LastLoginType_phone)
    {
        NSString *loginId   = [M8UserDefault getLoginId];
        NSString *loginPwd  = [M8UserDefault getLoginPwd];
        
        if (!(loginId && loginId.length &&
              loginPwd && loginPwd.length))
        {
            [[AppDelegate sharedAppDelegate] enterLoginUI];
            
            return ;
        }
        else
        {
            
            [loginWeb M8AutoLoginWithIdentifier:loginId
                                       password:loginPwd
                                     failHandle:^{
                                         
                                         [[AppDelegate sharedAppDelegate] enterLoginUI];
                                     }];
        }
    }
    else
    {
        [[AppDelegate sharedAppDelegate] enterLoginUI];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [M8UserDefault setAppLaunching:NO];
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kAppLaunchingNet_Notification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
