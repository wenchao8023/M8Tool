//
//  M8LiveChildViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveChildViewController.h"
#import "M8LiveHeaderView.h"
#import "M8LiveDeviceView.h"


@interface M8LiveChildViewController ()

@property (nonatomic, strong) M8LiveHeaderView *headerView;
@property (nonatomic, strong) M8LiveDeviceView *deviceView;



@end

@implementation M8LiveChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始位置
    self.view.bounds = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    
    [self loadSubviews];
    
    [self setCurrentFrame];
}


- (void)didMoveToParentViewController:(UIViewController *)parent {
    WCLog(@"livc child did move to parent vc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)updateFrameWithOffsetY:(CGFloat)offsetY {
    self.view.y = offsetY;
}

#pragma mark - setCurrentFrame
- (void)setCurrentFrame {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(horizontPan:)];
    [self.view addGestureRecognizer:panGesture];
    
}

- (void)horizontPan:(UIPanGestureRecognizer *)panGesture {
    
}


#pragma mark - 添加子视图
- (void)loadSubviews {
    
    // 设置第二页的蒙版
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [self.view addSubview:effectView];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.deviceView];
}

- (M8LiveHeaderView *)headerView {
    if (!_headerView) {
        M8LiveHeaderView *headerView = [[M8LiveHeaderView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, kDefaultNaviHeight)];
        _headerView = headerView;
    }
    return _headerView;
}

- (M8LiveDeviceView *)deviceView {
    if (!_deviceView) {
        M8LiveDeviceView *deviceView = [[M8LiveDeviceView alloc] initWithFrame:CGRectMake(self.view.width, self.view.height - kBottomHeight, self.view.width, kBottomHeight) deviceType:M8LiveDeviceTypeHost];
        _deviceView = deviceView;
    }
    return _deviceView;
}



@end
