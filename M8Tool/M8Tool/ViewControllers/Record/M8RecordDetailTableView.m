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
#import "M8MeetWindow.h"
#import "M8MakeCallViewController.h"

#define kItemWidth (self.width - 60) / 5
#define kSectionHeight 118.f

@interface M8RecordDetailTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataItemArray;

@property (nonatomic, strong) NSMutableArray *dataContentArray;

@property (nonatomic, strong) M8MeetListModel *dataModel;

@property (nonatomic, strong) M8RecordDetailCollection *detailCollection;

@end


@implementation M8RecordDetailTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataModel:(M8MeetListModel *)model {
    if (self = [super initWithFrame:frame style:style]) {
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

- (M8RecordDetailCollection *)detailCollection {
    if (!_detailCollection) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.headerReferenceSize = CGSizeMake(self.width, kSectionHeight);
        flowLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
        
        M8RecordDetailCollection *detailCollection = [[M8RecordDetailCollection alloc] initWithFrame:CGRectMake(0, kDefaultCellHeight * 4, self.width, self.height - kDefaultCellHeight * 4) collectionViewLayout:flowLayout];
        [self addSubview:(_detailCollection = detailCollection)];
    }
    
    return _detailCollection;
}


- (NSMutableArray *)dataItemArray {
    if (!_dataItemArray) {
        _dataItemArray = [NSMutableArray arrayWithCapacity:0];
        [_dataItemArray addObjectsFromArray:@[@"会议主题", @"主持人", @"会议时间", @"参会人数"]];
    }
    return _dataItemArray;
}

- (NSMutableArray *)dataContentArray {
    if (!_dataContentArray) {
        NSMutableArray *dataContentArray = [NSMutableArray arrayWithCapacity:0];
        [dataContentArray addObject:_dataModel.recordTopic];
        [dataContentArray addObject:_dataModel.recordLuancher];
        [dataContentArray addObject:_dataModel.recordTime];
        [dataContentArray addObject:[NSString stringWithFormat:@"%ld人", _dataModel.recordMembers.count]];
        _dataContentArray = dataContentArray;
        
        [self reloadData];
    }
    return _dataContentArray;
}

- (void)reloadData {
    [super reloadData];
    
    [self.detailCollection configDataArray:_dataModel.recordMembers];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetingLuanchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingLuanchCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingLuanchCell" owner:self options:nil] firstObject];
    }
                       [cell configWithItem:self.dataItemArray[indexPath.row]
                 content:self.dataContentArray[indexPath.row]];
    return cell;
}


- (void)reluanch {
    
    NSString *typeStr = _dataModel.recordType;
    if ([typeStr containsString:@"live"]) {
        [AppDelegate showAlertWithTitle:@"提示" message:@"暂时没有提供直播重新发起" okTitle:@"确定" cancelTitle:nil ok:nil cancel:nil];
    }
    else {
        M8MakeCallViewController *callVC = [[M8MakeCallViewController alloc] init];
        NSMutableArray *membersArray = [NSMutableArray arrayWithArray:_dataModel.recordMembers];
        NSString *loginIdentify = [[ILiveLoginManager getInstance] getLoginId];
        if ([membersArray containsObject:loginIdentify]) {
            [membersArray removeObject:loginIdentify];
        }
        
        callVC.membersArray = membersArray;
        callVC.callId       = [[AppDelegate sharedAppDelegate] getRoomID];
        callVC.topic        = _dataModel.recordTopic;
        if ([typeStr containsString:@"video"]) {
            callVC.callType = TILCALL_TYPE_VIDEO;
        }
        if ([typeStr containsString:@"audio"]) {
            callVC.callType = TILCALL_TYPE_AUDIO;
        }
        [M8MeetWindow M8_addCallSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
    }
}



@end
