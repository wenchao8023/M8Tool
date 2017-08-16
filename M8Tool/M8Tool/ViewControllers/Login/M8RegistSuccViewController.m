//
//  M8RegistSuccViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RegistSuccViewController.h"

#import "M8LoginWebService.h"

@interface M8RegistSuccViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *psdFirstTF;
@property (weak, nonatomic) IBOutlet UITextField *psdSecondTF;

@end

@implementation M8RegistSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加滑动返回
    [self addSwipeBack];
}

- (void)addSwipeBack
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
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
    
    
    if (_setPwdType == SetPwdTypeForgetPwd)
    {
        [self resetPassWord];
    }
    else
    {
        [self regist];
    }
}

- (IBAction)onBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 重设密码
 */
- (void)resetPassWord
{
    LoadView *regWaitView = [LoadView loadViewWith:@"重置密码"];
    [self.view addSubview:regWaitView];
    
    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    [webService m8ResetPwdWithPhoneNumber:_phoneNum
                                      pwd:_psdSecondTF.text
                                 veriCode:_veriCode
                             cancelHandle:^{
        
        [regWaitView removeFromSuperview];
    }];
}

/**
 注册
 */
- (void)regist
{
    LoadView *regWaitView = [LoadView loadViewWith:@"正在注册"];
    [self.view addSubview:regWaitView];

    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    [webService M8RegistWithIdentifier:_phoneNum
                                  nick:_nickName
                                   pwd:_psdSecondTF.text
                              veriCode:_veriCode cancelHandle:^{
                                  
        [regWaitView removeFromSuperview];
    }];
}

@end
