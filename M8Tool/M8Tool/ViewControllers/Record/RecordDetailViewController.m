//
//  RecordDetailViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "RecorDetailView.h"

@interface RecordDetailViewController ()

@property (nonatomic, strong) RecorDetailView *detailView;

@property (nonatomic, strong) UIButton *reluanchBtn;

@end

@implementation RecordDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议详情"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.contentView setHeight:kContentHeight_bottom90];
    
    [self.contentView addSubview:self.detailView];
    [self.view insertSubview:self.reluanchBtn belowSubview:self.contentView];
}

- (RecorDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[RecorDetailView alloc] initWithFrame:self.contentView.bounds];
        _detailView.backgroundColor = WCClear;
    }
    return _detailView;
}

- (UIButton *)reluanchBtn {
    if (!_reluanchBtn) {
        UIButton *reluanchBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(0, 0, 80, 80)
                                                               Target:self
                                                               Action:@selector(reluanchAction)
                                                            ImageName:@""
                                 ];
        [reluanchBtn setCenterX:self.view.centerX];
        [reluanchBtn setAttributedTitle:[CommonUtil customAttString:@"重新发起"
                                                           fontSize:kAppMiddleFontSize
                                                          textColor:WCBlack
                                                          charSpace:kAppKern_0]
                               forState:UIControlStateNormal
         ];
        [reluanchBtn setCenterX:self.view.centerX];
        [reluanchBtn setY:CGRectGetMaxY(self.contentView.frame) - 40];
        [reluanchBtn setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [reluanchBtn setBackgroundColor:WCBgColor];
        WCViewBorder_Radius(reluanchBtn, 40);
        [self.view addSubview:(_reluanchBtn = reluanchBtn)];
    }
    return _reluanchBtn;
}

- (void)reluanchAction {
    WCLog(@"重新发起会议");
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
