//
//  M8RecordDetailTableView.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecordDetailTableView.h"

#import "MeetingLuanchCell.h"   /// 使用会议发起界面中的 cell
#import "M8MeetListModel.h"

#import "M8RecordDetailCollection.h"
//#import "M8MeetWindow.h"
//#import "M8MakeCallViewController.h"

#define kItemWidth (self.width - 60) / 5
#define kSectionHeight 118.f


@interface M8RecordDetailTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataItemArray;

@property (nonatomic, strong) NSMutableArray *dataContentArray;

@property (nonatomic, strong) M8MeetListModel *dataModel;

@property (nonatomic, strong) M8RecordDetailCollection *detailCollection;

@end


@implementation M8RecordDetailTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataModel:(M8MeetListModel *)model
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor = WCClear;
        self.scrollEnabled = NO;
        self.delegate   = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _dataModel = model;
        
        [self detailCollection];
        [self dataContentArray];
    }
    return self;
}

- (M8RecordDetailCollection *)detailCollection
{
    if (!_detailCollection)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.headerReferenceSize = CGSizeMake(self.width, kSectionHeight);
        flowLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
        
        M8RecordDetailCollection *detailCollection = [[M8RecordDetailCollection alloc] initWithFrame:CGRectMake(0, kDefaultCellHeight * 4, self.width, self.height - kDefaultCellHeight * 4)
                                                                                collectionViewLayout:flowLayout
                                                                                           dataModel:_dataModel
                                                      ];
        [self addSubview:(_detailCollection = detailCollection)];
    }
    
    return _detailCollection;
}


- (NSMutableArray *)dataItemArray
{
    if (!_dataItemArray)
    {
        _dataItemArray = [NSMutableArray arrayWithCapacity:0];
        [_dataItemArray addObjectsFromArray:@[@"会议主题", @"主持人", @"会议时间", @"参会人数"]];
    }
    return _dataItemArray;
}

- (NSMutableArray *)dataContentArray
{
    if (!_dataContentArray)
    {
        NSMutableArray *dataContentArray = [NSMutableArray arrayWithCapacity:0];
        [dataContentArray addObject:_dataModel.title];
        [dataContentArray addObject:_dataModel.mainuser];
        [dataContentArray addObject:[CommonUtil getDateStrWithTime:[_dataModel.starttime doubleValue]]];
        [dataContentArray addObject:[NSString stringWithFormat:@"%lu人", _dataModel.members.count]];
        _dataContentArray = dataContentArray;
        
        [self reloadData];
    }
    return _dataContentArray;
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingLuanchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingLuanchCellID"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingLuanchCell" owner:self options:nil] firstObject];
        
        WCWeakSelf(self);
        cell.onCollectMeetBlock = ^{
          
            [weakself onNetCollectMeet];
        };
        
        cell.onCancelMeetBlock = ^{
          
            [weakself onNetCancelCollectionMeet];
        };
    }
    
    if (indexPath.row < self.dataContentArray.count)
    {
        if (indexPath.row == 0)
        {
            [cell configWithItem:self.dataItemArray[indexPath.row]
                         content:self.dataContentArray[indexPath.row]
                       isCollect:self.dataModel.collect];
        }
        else
        {
            [cell configWithItem:self.dataItemArray[indexPath.row]
                         content:self.dataContentArray[indexPath.row]];
        }
    }
    
    return cell;
}


/**
 收藏会议
 */
- (void)onNetCollectMeet
{
    WCWeakSelf(self);
    MeetCollectRequest *mcReq = [[MeetCollectRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        weakself.dataModel.collect = 1;
        [weakself reloadData];
        [WCNotificationCenter postNotificationName:kMeetCollcet_Notification object:weakself.dataModel];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    mcReq.token = [AppDelegate sharedAppDelegate].token;
    mcReq.uid   = [M8UserDefault getLoginId];
    mcReq.mid   = [self.dataModel.mid intValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:mcReq];
}

/**
 取消收藏会议
 */
- (void)onNetCancelCollectionMeet
{
    WCWeakSelf(self);
    MeetCancelCRequest *mccReq = [[MeetCancelCRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        weakself.dataModel.collect = 0;
        [weakself reloadData];
        [WCNotificationCenter postNotificationName:kMeetCollcet_Notification object:weakself.dataModel];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    mccReq.token = [AppDelegate sharedAppDelegate].token;
    mccReq.uid   = [M8UserDefault getLoginId];
    mccReq.mid   = [self.dataModel.mid intValue];
    [[WebServiceEngine sharedEngine] AFAsynRequest:mccReq];
}


- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kMeetCollcet_Notification object:nil];
}



@end
