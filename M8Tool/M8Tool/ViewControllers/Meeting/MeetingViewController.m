//
//  MeetingViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingViewController.h"


@interface MeetingViewController ()

@end

@implementation MeetingViewController




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议中心"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reloadSuperViews];
}



- (void)reloadSuperViews {
    
    self.contentView.hidden = YES;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.view setHeight:SCREEN_HEIGHT - kDefaultTabbarHeight];
   
    self.bgImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:self.bgImageView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
