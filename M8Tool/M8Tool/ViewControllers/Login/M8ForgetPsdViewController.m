//
//  M8ForgetPsdViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8ForgetPsdViewController.h"



@interface M8ForgetPsdViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *veriCodeTF;

@end

@implementation M8ForgetPsdViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加滑动返回
    [self addSwipeBack];
    
    // Do any additional setup after loading the view.
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

- (IBAction)onBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *registSuccVC = [segue destinationViewController];
    [registSuccVC setValue:@(0) forKey:@"setPwdType"];
}

/**
 获取验证码
 
 @param sender sender description
 */
- (IBAction)onGetVerificationCodeAction:(id)sender {
    
}




@end
