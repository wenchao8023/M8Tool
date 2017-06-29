//
//  M8NoteDetailViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8NoteDetailViewController.h"

#import "M8NoteDetailTableView.h"



@interface M8NoteDetailViewController ()

@property (nonatomic, strong) M8NoteDetailTableView *detailTableView;

@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation M8NoteDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议收藏详情"];
}

- (M8NoteDetailTableView *)detailTableView {
    if (!_detailTableView) {
//        M8NoteDetailTableView *detailTableView = [[M8NoteDetailTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain dataModel:_dataModel];
//        _detailTableView = detailTableView;
    }
    return _detailTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.contentView addSubview:self.detailTableView];
//    [self.view bringSubviewToFront:self.reluanchBtn];
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        UIButton *shareButton = [WCUIKitControl createButtonWithFrame:CGRectMake(0, 0, 80, 40)
                                                               Target:self
                                                               Action:@selector(shareAction)
                                                            ImageName:@""
                                 ];
        [shareButton setCenterX:self.view.centerX];
        [shareButton setY:CGRectGetMaxY(self.contentView.frame) - 40];
        [shareButton setBackgroundImage:kGetImage(@"recordreluanch") forState:UIControlStateNormal];
        [self.view addSubview:(_shareButton = shareButton)];
    }
    return _shareButton;
}

- (void)shareAction {
    [self.detailTableView shareAction];
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
