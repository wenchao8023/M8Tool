//
//  M8MeetAgendaViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetAgendaViewController.h"

@interface M8MeetAgendaViewController ()

@end

@implementation M8MeetAgendaViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self setHeaderTitle:@"会议日程"];
    self.headerView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.contentView setHidden:YES];
    
    NSString *imgStr = nil;
    
    if (iPhone4)
    {
        imgStr = @"meetAgent4";
    }
    else if (iPhone5)
    {
        imgStr = @"meetAgent5";
    }
    else if (iPhone6P)
    {
        imgStr = @"meetAgent6p";
    }
    else
    {
        imgStr = @"meetAgent6";
    }
    
    self.bgImageView.image = kGetImage(imgStr);
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
