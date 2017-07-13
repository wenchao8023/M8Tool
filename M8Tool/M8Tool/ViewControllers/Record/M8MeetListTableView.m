//
//  M8MeetListTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListTableView.h"
#import "M8MeetListCell.h"

#import "M8MeetListTableView+UI.h"
#import "M8MeetListTableView+Net.h"


@interface M8MeetListTableView ()<UITableViewDelegate, UITableViewDataSource>

@end



@implementation M8MeetListTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style listViewType:(M8MeetListViewType)listViewType
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;

        _listViewType = listViewType;
        
        WCWeakSelf(self);
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself loadNetData];
        }];
    
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        
        [self loadNetData];
    }
    return self;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        _dataArray = dataArray;
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    M8MeetListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M8MeetListCellID"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"M8MeetListCell" owner:self options:nil] firstObject];
    }
    
    if (self.dataArray.count)
    {
        [cell config:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tbleView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
