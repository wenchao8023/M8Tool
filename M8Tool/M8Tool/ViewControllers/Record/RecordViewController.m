//
//  RecordViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableView.h"


@interface RecordViewController ()

@property (nonatomic, strong) RecordTableView *tableView;

@end

@implementation RecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.contentView setHeight:kContentHeight_bottom30];
    [self.contentView addSubview:self.tableView];
}

- (RecordTableView *)tableView {
    if (!_tableView) {
        _tableView = [[RecordTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}


#pragma mark - 判断视图类型
- (NSString *)getTitle {
    switch (self.recordViewType) {
        case RecordViewType_record:
            return @"会议记录";
            break;
        case RecordViewType_note:
            return @"会议笔记";
            break;
        case RecordViewType_collect:
            return @"会议收藏";
            break;
        default:
            break;
    }
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
