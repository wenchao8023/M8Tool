//
//  RecordTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordTableView.h"
#import "RecordCell.h"
#import "RecordDetailViewController.h"


@interface RecordTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RecordTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordDetailViewController *destinationVC = [[RecordDetailViewController alloc] init];
    destinationVC.isExitLeftItem = YES;
    [[[AppDelegate sharedAppDelegate] navigationViewController] pushViewController:destinationVC animated:YES];
}

@end
