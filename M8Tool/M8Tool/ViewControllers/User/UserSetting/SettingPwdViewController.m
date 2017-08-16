//
//  SettingPwdViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "SettingPwdViewController.h"

#import "SettingPasswordView.h"



@interface SettingPwdViewController ()

@property (nonatomic, strong, nullable) SettingPasswordView *settingPwdView;

@end



@implementation SettingPwdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"设置密码"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    WCWeakSelf(self);
    self.settingPwdView.succHandle = ^(NSString * _Nullable info) {
      
//        [AlertHelp tipWith:@"设置密码成功" wait:1];
        
        [M8UserDefault setLoginPwd:info];
        
        [weakself.navigationController popViewControllerAnimated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SettingPasswordView *)settingPwdView
{
    if (!_settingPwdView)
    {
        SettingPasswordView *settingPwdView = [[SettingPasswordView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:(_settingPwdView = settingPwdView)];
    }
    
    return _settingPwdView;
}


@end
