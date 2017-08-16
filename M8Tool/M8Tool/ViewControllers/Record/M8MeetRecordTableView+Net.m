//
//  M8MeetRecordTableView+Net.m
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRecordTableView+Net.h"


@implementation M8MeetRecordTableView (Net)

- (void)loadNetData
{
    if (![AppDelegate sharedAppDelegate].netEnable)
    {
        [AlertHelp tipWith:@"网络连接异常" wait:1];
        [self endAllRefresh:NO];
        return ;
    }
    
    self.pageNums   = 20;
    self.pageOffset = 0;
    [self.dataArray removeAllObjects];
    if (self.mj_footer.state == MJRefreshStateNoMoreData)
    {
        [self.mj_footer resetNoMoreData];
    }
    
    [self loadDataWithOffset:self.pageOffset];
}

- (void)loadMoreData
{
    if (![AppDelegate sharedAppDelegate].netEnable)
    {
        [AlertHelp tipWith:@"网络连接异常" wait:1];
        [self endAllRefresh:NO];
        return ;
    }
    
    self.pageOffset = (int)self.dataArray.count;
    
    [self loadDataWithOffset:self.pageOffset];
}


/**
 请求网络数据

 @param offset 偏移位置
 */
- (void)loadDataWithOffset:(int)offset
{
    /**
     * 会议记录 和 会议收藏 的数据类型基本一致
     *  会议记录 比 会议收藏 返回多一个 collect 字段，用于判断是否被收藏
     *  会议收藏中的数据都是默认是收藏的
     */
    if (self.listViewType == M8MeetListViewTypeRecord)
    {
        [self loadRecordData:offset];
    }
    else if (self.listViewType == M8MeetListViewTypeCollect)
    {
        [self loadCollectData:offset];
    }
    
}


- (void)loadRespondData:(MeetsListResponseData *)responseData
{
    for (NSDictionary *dataDic in responseData.meets)
    {
        M8MeetRecordModel *model = [[M8MeetRecordModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        
        if (self.listViewType == M8MeetListViewTypeCollect) //如果是会议收藏中获取到的数据，需要本地添加一个 collect = 1
        {
            model.collect = 1;
        }
        
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


/**
 请求会议记录数据

 @param offset 偏移位置
 */
- (void)loadRecordData:(int)offset
{
    WCWeakSelf(self);
    MeetsListRequest *listReq = [[MeetsListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        MeetsListResponseData *listData = (MeetsListResponseData *)request.response.data;
        [weakself loadRespondData:listData];
        
        [weakself endAllRefresh:NO];
        
    } failHandler:^(BaseRequest *request) {
        
        [weakself endAllRefresh:(request.response.errorCode == 10086)];
    }];
    
    listReq.token = [AppDelegate sharedAppDelegate].token;
    listReq.uid   = [M8UserDefault getLoginId];
    listReq.offset= offset;
    listReq.nums  = self.pageNums;
    [[WebServiceEngine sharedEngine] AFAsynRequest:listReq];
}


/**
 请求会议收藏数据

 @param offset 偏移位置
 */
- (void)loadCollectData:(int)offset
{
    WCWeakSelf(self);
    MeetsCollectRequest *collectReq = [[MeetsCollectRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        MeetsListResponseData *listData = (MeetsListResponseData *)request.response.data;
        [weakself loadRespondData:listData];
        
        [weakself endAllRefresh:NO];
        
    } failHandler:^(BaseRequest *request) {
        
        [weakself endAllRefresh:(request.response.errorCode == 10086)];
    }];
    
    collectReq.token = [AppDelegate sharedAppDelegate].token;
    collectReq.uid   = [M8UserDefault getLoginId];
    collectReq.offset= offset;
    collectReq.nums  = self.pageNums;
    [[WebServiceEngine sharedEngine] AFAsynRequest:collectReq];
}

- (void)endAllRefresh:(BOOL)isNOMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mj_header.isRefreshing)
        {
            [self.mj_header endRefreshing];
        }
        
        if (self.mj_footer.isRefreshing)
        {
            if (isNOMoreData)
            {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.mj_footer endRefreshing];
            }
        }
    });
}

@end
