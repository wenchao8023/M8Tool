//
//  M8RegistViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RegistViewController.h"

#import "M8LoginWebService.h"

@interface M8RegistViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSTimer *_waitVerifyTimer;
    NSTimeInterval _waitTime;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *veriCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;





@end

@implementation M8RegistViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加滑动返回
    [self addSwipeBack];
    
    
    _nextBtn.enabled = NO;
    [_nextBtn setTitleColor:WCLightGray forState:UIControlStateDisabled];
    [_nextBtn setTitleColor:WCDarkGray forState:UIControlStateNormal];
    
    [_veriCodeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *registSuccVC = [segue destinationViewController];
    [registSuccVC setValue:@(1) forKey:@"setPwdType"];
    [registSuccVC setValue:_userNameTF.text forKey:@"userName"];
    [registSuccVC setValue:_phoneNumTF.text forKey:@"phoneNum"];
}



#pragma mark - actions
- (IBAction)onBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 获取验证码
 
 @param sender sender description
 */
- (IBAction)onGetVerificationCodeAction:(id)sender {
    
    _nextBtn.enabled = NO;
    
    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    WCWeakSelf(self);
    [webService M8GetVerifyCode:_phoneNumTF.text succHandle:^{
        [weakself getVerifyCodeSucc];
    }];
}

- (void)getVerifyCodeSucc
{
    _verifyCodeBtn.enabled = NO;
    _waitTime = 60;
    _waitVerifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitVerifyCode) userInfo:nil repeats:YES];
    [_waitVerifyTimer fire];
}

- (void)waitVerifyCode
{
    if (_waitTime > 0)
    {
        [UIView setAnimationsEnabled:NO];
        [_verifyCodeBtn setTitle:[NSString stringWithFormat:@"重新获取验证码(%ds)", (int)_waitTime--] forState:UIControlStateDisabled];
    }
    else
    {
        [UIView setAnimationsEnabled:YES];
        _verifyCodeBtn.enabled = YES;
        [_verifyCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [_waitVerifyTimer invalidate];
        _waitVerifyTimer = nil;
    }
}

/**
 服务条款

 @param sender sender description
 */
- (IBAction)onServiceProtocolAction:(id)sender {
    
}


/**
 隐私条款
 
 @param sender sender description
 */
- (IBAction)onPrivacyPolicyAction:(id)sender {
    
}

#pragma mark - textFieldDidChange
- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField isEqual:_veriCodeTF] &&
        textField.text.length == 6)
    {
        LoadView *loadView = [LoadView loadViewWith:@"正在验证"];
        [self.view addSubview:loadView];
        
        WCWeakSelf(self);
        M8LoginWebService *webService = [[M8LoginWebService alloc] init];
        [webService M8VerifyVerifyCode:_phoneNumTF.text
                            verifyCode:_veriCodeTF.text
                            succHandle:^{
                                weakself.nextBtn.enabled = YES;
                                [loadView removeFromSuperview];
                            }
                            failHandle:^{
                                weakself.nextBtn.enabled = NO;
                                [loadView removeFromSuperview];
                            }
         ];
    }
}


@end
