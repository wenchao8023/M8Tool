//
//  M8LoginViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginViewController.h"
#import "MainTabBarController.h"
#import "UserProtocolViewController.h"

#import "M8LoginWebService.h"

@interface M8LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
    
@end






@implementation M8LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self getUserDefault];
    
    if (!_isLogout) {
//        [self autoLogin];
    }
    
}
    
- (void)autoLogin {
    [self loginName:_userNameTF.text pwd:_passwordTF.text];
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
#pragma mark - UI
- (void)enterMainUI {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSNumber *has = [[NSUserDefaults standardUserDefaults] objectForKey:kUserProtocol];
    if (!has || !has.boolValue)
    {
        UserProtocolViewController *vc = [[UserProtocolViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        appDelegate.window.rootViewController = nav;
        return;
    }
    
    MainTabBarController *tabBarVC = [[MainTabBarController alloc] init];
    appDelegate.window.rootViewController = tabBarVC;
}
    
    
    
    
    
#pragma mark - onActions
- (IBAction)onLoginAction:(id)sender {
    WCLog(@"登录");
    
    if (!_userNameTF || _userNameTF.text.length < 1)
    {
        [AlertHelp alertWith:@"提示" message:@"用户名无效" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        
        return;
    }
    if (!_passwordTF || _passwordTF.text.length < 1)
    {
        [AlertHelp alertWith:@"提示" message:@"密码无效" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    
    [self loginName:_userNameTF.text pwd:_passwordTF.text];
}

- (IBAction)onMoreAction:(id)sender {
    
}


- (void)loginName:(NSString *)identifier pwd:(NSString *)pwd
{
    LoadView *loginWaitView = [LoadView loadViewWith:@"正在登录"];
    [self.view addSubview:loginWaitView];
    
    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    [webService M8LoginWithIdentifier:identifier password:pwd cancelPVN:^{
        [loginWaitView removeFromSuperview];
    }];
}

- (void)getUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:kLoginIdentifier];
    NSString *pwd = [userDefaults objectForKey:kLoginPassward];
    self.userNameTF.text = name;
    self.passwordTF.text = pwd;
}

- (void)setUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = self.userNameTF.text;
    NSString *pwd = self.passwordTF.text;
    [userDefaults setObject:name forKey:kLoginIdentifier];
    [userDefaults setObject:pwd forKey:kLoginPassward];
    [userDefaults synchronize];
}


    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
