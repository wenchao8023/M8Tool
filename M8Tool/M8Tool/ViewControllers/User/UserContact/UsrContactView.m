//
//  UsrContactView.m
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"
#import "UsrContactHeaderView.h"


static const CGFloat kHeaderHeight = 60;


@interface UsrContactView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end


@implementation UsrContactView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = WCClear;
        self.tableHeaderView = [[UsrContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, kHeaderHeight)];
    }
    return self;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithCapacity:0];
        [_sectionArray addObjectsFromArray:@[@"研发部", @"销售部", @"市场部", @"行政部", @"人事部"]];
    }
    return _sectionArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        [_dataArray addObjectsFromArray:@[@[@"研发1", @"研发2", @"研发3", @"研发4", @"研发5", @"研发6"],
                                          @[@"销售1", @"销售2", @"销售3", @"销售4", @"销售5", @"销售6" ],
                                          @[@"市场1", @"市场2", @"市场3", @"市场4", @"市场5", @"市场6", @"市场7", @"市场8"],
                                          @[@"行政1", @"行政2", @"行政3", @"行政4"],
                                          @[@"人事1", @"人事2", @"人事3"]
                                          ]
         ];
    }
    return _dataArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray && self.dataArray.count) {
        return [self.dataArray[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UsrContactViewID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = WCClear;
    }
    
    if (self.dataArray && self.dataArray.count &&
        self.dataArray[indexPath.section] && [self.dataArray[indexPath.section] count]) {
        cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hView = [WCUIKitControl createViewWithFrame:CGRectMake(0, 0, self.width, 40) BgColor:WCClear];
    UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(kMarginView_horizontal, 0, 100, 40) BgColor:WCClear];
    titleLabel.text = self.sectionArray[section];
    [hView addSubview:titleLabel];
    return hView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


@end
