//
//  M8RegistSuccViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RegistSuccViewController.h"

#import "M8LoginWebService.h"

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

#pragma mark - 确认注册
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

    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    [webService M8RegistWithIdentifier:_phoneNum nick:_userName pwd:_psdSecondTF.text cancelHandle:^{
        [regWaitView removeFromSuperview];
    }];
}

@end
