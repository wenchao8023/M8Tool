//
//  M8RegistViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RegistViewController.h"

@interface M8RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *veriCodeTF;


@end

@implementation M8RegistViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBarHidden = NO;
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
    // Pass the selected object to the new view controller.
}
*/


/**
 获取验证码
 
 @param sender sender description
 */
- (IBAction)onGetVerificationCodeAction:(id)sender {
    
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

@end
