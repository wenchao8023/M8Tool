//
//  M8RecordDetailViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecordDetailViewController.h"
#import "M8RecordDetailTableView.h"

@interface M8RecordDetailViewController ()

@property (nonatomic, strong) M8RecordDetailTableView *detailTableView;

@property (nonatomic, strong) UIButton *reluanchBtn;

@end

@implementation M8RecordDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.contentView addSubview:self.detailTableView];
    [self.view bringSubviewToFront:self.reluanchBtn];
}

- (M8RecordDetailTableView *)detailTableView {
    if (!_detailTableView) {
        M8RecordDetailTableView *detailTableView = [[M8RecordDetailTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain dataModel:_dataModel];
        _detailTableView = detailTableView;
    }
    return _detailTableView;
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


@end
