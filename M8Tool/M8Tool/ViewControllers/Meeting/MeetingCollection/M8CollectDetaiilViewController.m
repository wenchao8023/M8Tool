//
//  M8CollectDetaiilViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CollectDetaiilViewController.h"
#import "M8CollectDetailTableView.h"


@interface M8CollectDetaiilViewController ()

@property (nonatomic, strong) M8CollectDetailTableView *detailTableView;

@property (nonatomic, strong) UIButton *reluanchBtn;

@end

@implementation M8CollectDetaiilViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议收藏详情"];
}

- (M8CollectDetailTableView *)detailTableView {
    if (!_detailTableView) {
        M8CollectDetailTableView *detailTableView = [[M8CollectDetailTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain dataModel:_dataModel];
        _detailTableView = detailTableView;
    }
    return _detailTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.contentView addSubview:self.detailTableView];
    [self.view bringSubviewToFront:self.reluanchBtn];
}

- (UIButton *)reluanchBtn {
    if (!_reluanchBtn) {
        UIButton *reluanchBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(0, 0, 80, 40)
                                                               Target:self
                                                               Action:@selector(reluanchAction)
                                                            ImageName:@""
                                 ];
        [reluanchBtn setCenterX:self.view.centerX];
        [reluanchBtn setY:CGRectGetMaxY(self.contentView.frame) - 40];
        [reluanchBtn setBackgroundImage:kGetImage(@"recordreluanch") forState:UIControlStateNormal];
        [self.view addSubview:(_reluanchBtn = reluanchBtn)];
    }
    return _reluanchBtn;
}

- (void)reluanchAction {
    [self.detailTableView reluanch];
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
