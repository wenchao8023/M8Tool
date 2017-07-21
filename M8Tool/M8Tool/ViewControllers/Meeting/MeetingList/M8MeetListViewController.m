//
//  M8MeetListViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListViewController.h"

@interface M8MeetListViewController ()

@end

@implementation M8MeetListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self reloadSuperViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议列表"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadSuperViews {
    
    self.contentView.hidden = YES;
    
    [self.view sendSubviewToBack:self.bgImageView];
}


@end
