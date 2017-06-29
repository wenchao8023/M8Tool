//
//  M8MutiLoginViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MutiLoginViewController.h"

@interface M8MutiLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *experButton;



@end

@implementation M8MutiLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setBarTintColor:WCClear];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WCWhite,
                                                           NSFontAttributeName:[UIFont systemFontOfSize:kAppNaviFontSize]
                                                           }];
    
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
 体验

 @param sender sender
 */
- (IBAction)onExperAction:(id)sender {
    WCLog(@"onExperAction");
}


/**
 微信登录
 
 @param sender sender
 */
- (IBAction)onWechatAction:(id)sender {
    WCLog(@"onWechatAction");
}


/**
 企业微信登录
 
 @param sender sender
 */
- (IBAction)onCWechatAction:(id)sender {
    WCLog(@"onCWechatAction");
}


/**
 QQ登录
 
 @param sender sender
 */
- (IBAction)onQQAction:(id)sender {
    WCLog(@"onQQAction");
}


@end
