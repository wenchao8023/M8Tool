//
//  M8RegistSuccViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RegistSuccViewController.h"
#import "MainTabBarController.h"
#import "UserProtocolViewController.h"

@interface M8RegistSuccViewController ()

@property (weak, nonatomic) IBOutlet UITextField *psdFirstTF;
@property (weak, nonatomic) IBOutlet UITextField *psdSecondTF;





@end

@implementation M8RegistSuccViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    WCLog(@"%ld", (long)self.setPwdType);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
    // Pass the selected object                                                to the new view controller.
}
*/
- (IBAction)onVerifyAction:(id)sender {
    
    if (!_psdFirstTF || _psdSecondTF.text.length < 1)
    {
        [AlertHelp alertWith:@"提示" message:@"请输入密码" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    if (!_psdFirstTF || _psdSecondTF.text.length < 1)
    {
        [AlertHelp alertWith:@"提示" message:@"请再次输入密码" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    if (![_psdFirstTF.text isEqualToString:_psdSecondTF.text])
    {
        [AlertHelp alertWith:@"提示" message:@"两次输入不一致" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    
    
    if (_setPwdType == SetPwdTypeForgetPwd) {
        [self resetPassWord];
    }
    else {
        [self regist];
    }
}


/**
 重设密码
 */
- (void)resetPassWord {
    
}

/**
 注册
 */
- (void)regist {
    LoadView *regWaitView = [LoadView loadViewWith:@"正在注册"];
    [self.view addSubview:regWaitView];
    
    __weak typeof(self) ws = self;
    //向业务后台注册
    RegistRequest *registReq = [[RegistRequest alloc] initWithHandler:^(BaseRequest *request) {
        [regWaitView removeFromSuperview];
        
//        [ws loginName:ws.userName pwd:ws.psdSecondTF.text];
        
    } failHandler:^(BaseRequest *request) {
        [regWaitView removeFromSuperview];
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        NSLog(@"regist fail.%@",errinfo);
        [AlertHelp alertWith:@"注册失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
    }];
    registReq.nick = _userName;
    registReq.identifier = _phoneNum;
    registReq.pwd = _psdSecondTF.text;
    [[WebServiceEngine sharedEngine] asyncRequest:registReq];
}



- (void)enterMainUI
{
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
    
    [self rememberLoginStatu];
}

- (void)rememberLoginStatu {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(YES) forKey:kHasLogin];
    [defaults synchronize];
}

- (void)setUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = self.userName;
    NSString *pwd = self.psdSecondTF.text;
    [userDefaults setObject:name forKey:kLoginIdentifier];
    [userDefaults setObject:pwd forKey:kLoginPassward];
    [userDefaults synchronize];
}


@end
