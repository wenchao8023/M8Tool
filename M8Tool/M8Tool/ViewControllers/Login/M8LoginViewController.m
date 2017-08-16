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

@interface M8LoginViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
    
@end






@implementation M8LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UINavigationBar appearance] setBarTintColor:WCClear];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WCWhite,
                                                           NSFontAttributeName:[UIFont systemFontOfSize:kAppNaviFontSize]
                                                           }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加滑动返回
    [self addSwipeBack];
    
    [self getUserDefault];
}

- (void)addSwipeBack
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - onActions

- (IBAction)onBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


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

- (IBAction)onMoreAction:(id)sender
{
    
}


- (void)loginName:(NSString *)identifier pwd:(NSString *)pwd
{
    if (![AppDelegate sharedAppDelegate].netEnable)
    {
        [AlertHelp tipWith:@"网络连接异常" wait:1];
        
        return ;
    }
    
    LoadView *loginWaitView = [LoadView loadViewWith:@"正在登录"];
    [self.view addSubview:loginWaitView];
    
    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    [webService M8LoginWithIdentifier:identifier password:pwd cancelPVN:^{
        
        [loginWaitView removeFromSuperview];
    }];
}

- (void)getUserDefault
{
    if ([M8UserDefault getLastLoginType] == LastLoginType_phone)
    {
        NSString *name  = [M8UserDefault getLoginId];
        NSString *pwd   = [M8UserDefault getLoginPwd];
        self.userNameTF.text = name;
        self.passwordTF.text = pwd;
    }
}


    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
