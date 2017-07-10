//
//  M8MeetListTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListTableView.h"
#import "M8MeetListCell.h"
#import "M8MeetListModel.h"
#import "M8RecordDetailViewController.h"
#import "M8CollectDetaiilViewController.h"
#import "M8NoteDetailViewController.h"


@interface M8MeetListTableView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    CGFloat _lastOffsetY;
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int pageNums;
@property (nonatomic, assign) int pageOffset;



@end

@implementation M8MeetListTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
        
        _pageNums = 20;
        _pageOffset = 0;
        
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



- (void)loadNetData
{
    [self.dataArray removeAllObjects];
    _pageOffset = 0;
    
    [self loadDataWithOffset:_pageOffset];
}

- (void)loadMoreData
{
    _pageOffset += 1;
    
    [self loadDataWithOffset:_pageOffset];
}

- (void)loadDataWithOffset:(int)offset
{
    WCWeakSelf(self);
    MeetsListRequest *listReq = [[MeetsListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        MeetsListResponseData *listData = (MeetsListResponseData *)request.response.data;
        [weakself loadRespondData:listData];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    listReq.token = [AppDelegate sharedAppDelegate].token;
    listReq.uid   = [[ILiveLoginManager getInstance] getLoginId];
    listReq.offset= offset;
    listReq.nums  = _pageNums;
    [[WebServiceEngine sharedEngine] asyncRequest:listReq];
}

- (void)loadRespondData:(MeetsListResponseData *)responseData
{
    for (NSDictionary *dataDic in responseData.meets)
    {
        M8MeetListModel *model = [[M8MeetListModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        
        NSMutableArray *tempMembers = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *infoDic in model.members)
        {
            M8MeetMemberInfo *info = [[M8MeetMemberInfo alloc] init];
            [info setValuesForKeysWithDictionary:infoDic];
            [tempMembers addObject:info];
        }
        
        model.members = (NSArray *)tempMembers;
        [self.dataArray addObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self reloadData];
    });
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
    
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 会议记录
    if (_listViewType == M8MeetListViewTypeRecord)
    {
        M8RecordDetailViewController *destinationVC = [[M8RecordDetailViewController alloc] initWithDataModel:self.dataArray[indexPath.row]];
        destinationVC.isExitLeftItem = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:destinationVC];
    }
    // 会议笔记
    else if (_listViewType == M8MeetListViewTypeNote)
    {
        M8NoteDetailViewController *destinationVC = [[M8NoteDetailViewController alloc] init];
        destinationVC.isExitLeftItem = YES;
        destinationVC.dataModel = self.dataArray[indexPath.row];
        [[AppDelegate sharedAppDelegate] pushViewController:destinationVC];
    }
    // 会议收藏
    else if (_listViewType == M8MeetListViewTypeCollect)
    {
        M8CollectDetaiilViewController *destinationVC = [[M8CollectDetaiilViewController alloc] init];
        destinationVC.isExitLeftItem = YES;
        destinationVC.dataModel = self.dataArray[indexPath.row];
        [[AppDelegate sharedAppDelegate] pushViewController:destinationVC];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - scroll load more data
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self])
    {
        if (scrollView.contentSize.height - scrollView.contentOffset.y <= (self.height + 60.0))
        {
            [self loadMoreData];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lastOffsetY = scrollView.contentOffset.y;
}

@end
