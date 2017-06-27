//
//  M8LiveMakeViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveMakeViewController.h"


@interface M8LiveMakeViewController ()

@end

@implementation M8LiveMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self addChildVC];
}

- (void)addChildVC {
    
//    M8LiveChildViewController *childVC = [[M8LiveChildViewController alloc] init];
//    childVC.view.frame = self.view.bounds;
//    childVC.view.backgroundColor = WCClear;
//    [self addChildViewController:childVC];
//    [self.view insertSubview:childVC.view aboveSubview:self.bgImageView];
//    [childVC didMoveToParentViewController:self];
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
