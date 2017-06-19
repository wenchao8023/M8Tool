//
//  RecordTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordTableView.h"
#import "RecordCell.h"
#import "RecordModel.h"
#import "RecordDetailViewController.h"
#import "M8CollectDetaiilViewController.h"


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
        
        [self loadData];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        _dataArray = dataArray;
    }
    return _dataArray;
}
#warning Model 不应该在这里加载
- (void)loadData {
    RecordModel *model1 = [RecordModel new];
    model1.recordType = @"record_callType_video";
    model1.recordTopic = @"研发部的视频会议";
    model1.recordLuancher = @"user1";
    model1.recordTime = @"2017/6/19 15:07";
    model1.recordMembers = @[@"user1", @"user3", @"user2"];
    [self.dataArray addObject:model1];
    
    RecordModel *model2 = [RecordModel new];
    model2.recordType = @"record_callType_audio";
    model2.recordTopic = @"研发部的音频会议";
    model2.recordLuancher = @"user2";
    model2.recordTime = @"2017/6/19 13:35";
    model2.recordMembers = @[@"user1", @"user3", @"user2", @"user4", @"user5",];
    [self.dataArray addObject:model2];
    
    RecordModel *model3 = [RecordModel new];
    model3.recordType = @"record_callType_audio";
    model3.recordTopic = @"研发部的电话会议";
    model3.recordLuancher = @"木木";
    model3.recordTime = @"2017/6/19 10:10";
    model3.recordMembers = @[@"user1", @"user3"];
    [self.dataArray addObject:model3];
    
    RecordModel *model4 = [RecordModel new];
    model4.recordType = @"record_callType_live";
    model4.recordTopic = @"研发部的直播会议";
    model4.recordLuancher = @"木木";
    model4.recordTime = @"2017/6/18 20:07";
    model4.recordMembers = @[@"user1", @"user3"];
    [self.dataArray addObject:model4];
    
    RecordModel *model5 = [RecordModel new];
    model5.recordType = @"record_callType_video";
    model5.recordTopic = @"销售部的视频会议";
    model5.recordLuancher = @"user1";
    model5.recordTime = @"2017/6/18 18:37";
    model5.recordMembers = @[@"user1", @"user3", @"user2", @"user4", @"user5",];
    [self.dataArray addObject:model5];
    
    RecordModel *model6 = [RecordModel new];
    model6.recordType = @"record_callType_audio";
    model6.recordTopic = @"销售部的音频会议";
    model6.recordLuancher = @"木木";
    model6.recordTime = @"2017/6/18 12:02";
    model6.recordMembers = @[@"user1", @"user3", @"user2"];
    [self.dataArray addObject:model6];
    
    RecordModel *model7 = [RecordModel new];
    model7.recordType = @"record_callType_audio";
    model7.recordTopic = @"销售部的电话会议";
    model7.recordLuancher = @"木木";
    model7.recordTime = @"2017/6/18 10:00";
    model7.recordMembers = @[@"user1", @"user3", @"user2"];
    [self.dataArray addObject:model7];
    
    RecordModel *model8 = [RecordModel new];
    model8.recordType = @"record_callType_live";
    model8.recordTopic = @"销售部的直播会议";
    model8.recordLuancher = @"木木";
    model8.recordTime = @"2017/6/16 16:00";
    model8.recordMembers = @[@"user1", @"user3"];
    [self.dataArray addObject:model8];
    
    RecordModel *model9 = [RecordModel new];
    model9.recordType = @"record_callType_live";
    model9.recordTopic = @"企业文化宣传";
    model9.recordLuancher = @"木木";
    model9.recordTime = @"2017/6/16 10:00";
    model9.recordMembers = @[@"user1", @"user3"];
    [self.dataArray addObject:model9];
    
    RecordModel *model10 = [RecordModel new];
    model10.recordType = @"record_callType_live";
    model10.recordTopic = @"企业培训直播";
    model10.recordLuancher = @"木木";
    model10.recordTime = @"2017/6/15 10:30";
    model10.recordMembers = @[@"user1", @"user3", @"user2", @"user4", @"user5",];
    [self.dataArray addObject:model10];
    
    RecordModel *model11 = [RecordModel new];
    model11.recordType = @"record_callType_live";
    model11.recordTopic = @"企业新规直播";
    model11.recordLuancher = @"木木";
    model11.recordTime = @"2017/6/14 14:30";
    model11.recordMembers = @[@"user1", @"user3", @"user2"];
    [self.dataArray addObject:model11];
    
    RecordModel *model12 = [RecordModel new];
    model12.recordType = @"record_callType_live";
    model12.recordTopic = @"企业教育";
    model12.recordLuancher = @"木木";
    model12.recordTime = @"2017/6/14 11:30";
    model12.recordMembers = @[@"user1", @"user3", @"user4", @"user5"];
    [self.dataArray addObject:model12];
    
    RecordModel *model13 = [RecordModel new];
    model13.recordType = @"record_callType_video";
    model13.recordTopic = @"研发部的视频会议";
    model13.recordLuancher = @"木木";
    model13.recordTime = @"2017/6/13 10:00";
    model13.recordMembers = @[@"user1", @"user3", @"user2"];
    [self.dataArray addObject:model13];
    
    RecordModel *model14 = [RecordModel new];
    model14.recordType = @"record_callType_video";
    model14.recordTopic = @"研发部的视频会议";
    model14.recordLuancher = @"木木";
    model14.recordTime = @"2017/6/12 13:30";
    model14.recordMembers = @[@"user1", @"user3", @"user4", @"user5"];
    [self.dataArray addObject:model14];
    
    RecordModel *model15 = [RecordModel new];
    model15.recordType = @"record_callType_video";
    model15.recordTopic = @"研发部的视频会议";
    model15.recordLuancher = @"木木";
    model15.recordTime = @"2017/6/12 14:30";
    model15.recordMembers = @[@"user1", @"user3", @"user2", @"user4", @"user5",];
    [self.dataArray addObject:model15];
    
    [self reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil] firstObject];
    }
    
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.recordViewType == RecordViewType_collect) {
        M8CollectDetaiilViewController *destinationVC = [[M8CollectDetaiilViewController alloc] init];
        destinationVC.isExitLeftItem = YES;
        destinationVC.dataModel = self.dataArray[indexPath.row];
        [[[AppDelegate sharedAppDelegate] navigationViewController] pushViewController:destinationVC animated:YES];
    }
    else {
        RecordDetailViewController *destinationVC = [[RecordDetailViewController alloc] init];
        destinationVC.isExitLeftItem = YES;
        destinationVC.dataModel = self.dataArray[indexPath.row];
        [[[AppDelegate sharedAppDelegate] navigationViewController] pushViewController:destinationVC animated:YES];
    }
    
}

@end
