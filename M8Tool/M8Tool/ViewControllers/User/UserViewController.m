//
//  UserViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserViewController.h"
#import "UsrView.h"

@interface UserViewController ()

@property (nonatomic, strong) UsrView *userView;

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"深圳市音飙科技有限公司"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WCLog(@"用户界面");
    
//    [self.contentView setHeight:kContentHeight_bottom30];
    [self userView];
}

- (UsrView *)userView {
    if (!_userView) {
        UsrView *userView = [[UsrView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:(_userView = userView)];
    }
    return _userView;
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
