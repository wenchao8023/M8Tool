//
//  M8ThemeDetailViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8ThemeDetailViewController.h"

@interface M8ThemeDetailViewController ()

@end

@implementation M8ThemeDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImageView *preImageView = [WCUIKitControl createImageViewWithFrame:self.contentView.frame ImageName:self.imageStr];
    [self.view addSubview:preImageView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.hidden = YES;
    
    [self resetHeadView];
}

- (void)resetHeadView {
    UIButton *setBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - 60, kDefaultStatuHeight, 60, kDefaultCellHeight) Target:self Action:@selector(setAction) Title:@"设置"];
    [setBtn setAttributedTitle:[CommonUtil customAttString:@"设置" fontSize:kAppLargeFontSize textColor:WCWhite charSpace:kAppKern_4] forState:UIControlStateNormal];
    [self.headerView addSubview:setBtn];
}

- (void)setAction {
    WCLog(@"设置主题");
//    kAppBgImageStr 的设置
    
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在设置主题..."];
    [self.view addSubview:reqIdWaitView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [reqIdWaitView removeFromSuperview];
        
        kAppBgImageStr = @"launchImg";
    });
    
    
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

@end
