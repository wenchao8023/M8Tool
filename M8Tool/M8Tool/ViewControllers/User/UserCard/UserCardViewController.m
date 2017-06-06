//
//  UserCardViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserCardViewController.h"
#import "UsrCardView.h"

@interface UserCardViewController ()

@property (nonatomic, strong) UsrCardView *cardView;

@end

@implementation UserCardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"我的名片"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.contentView setHeight:kContentHeight_bottom30];
    [self cardView];
}

- (UsrCardView *)cardView {
    if (!_cardView) {
        UsrCardView *cardView = [[UsrCardView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:(_cardView = cardView)];
    }
    return _cardView;
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
