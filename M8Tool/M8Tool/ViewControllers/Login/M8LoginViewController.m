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
        [self autoLogin];
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
        [self showAlert:@"提示" message:@"用户名无效" okTitle:@"确定" cancelTitle:nil ok:nil cancel:nil];
        return;
    }
    if (!_passwordTF || _passwordTF.text.length < 1)
    {
        [self showAlert:@"提示" message:@"密码无效" okTitle:@"确定" cancelTitle:nil ok:nil cancel:nil];
        return;
    }
    
    [self loginName:_userNameTF.text pwd:_passwordTF.text];
}
    
- (void)loginName:(NSString *)name pwd:(NSString *)pwd {
    
    LoadView *loginWaitView = [LoadView loadViewWith:@"正在登录"];
    [self.view addSubview:loginWaitView];
    
    WCWeakSelf(self);
    [[ILiveLoginManager getInstance] tlsLogin:name pwd:pwd succ:^{
        [loginWaitView removeFromSuperview];
        NSLog(@"tillivesdkshow login succ");
        [weakself setUserDefault];
        [weakself enterMainUI];
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSString *errInfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
        NSLog(@"login fail.%@",errInfo);
        [loginWaitView removeFromSuperview];
        //errId=6208:离线被踢，此时再次登录即可
        if (errId == 6208)
            [weakself loginName:name pwd:pwd];
        else
            [weakself showAlert:@"提示" message:errInfo okTitle:@"确认" cancelTitle:nil ok:nil cancel:nil];
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
    
- (void)showAlert:(NSString *)title message:(NSString *)msg okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle ok:(ActionHandle)succ cancel:(ActionHandle)fail
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (okTitle)
    {
        [alert addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:succ]];
    }
    if (cancelTitle)
    {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:fail]];
    }
    [self presentViewController:alert animated:YES completion:nil];
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
