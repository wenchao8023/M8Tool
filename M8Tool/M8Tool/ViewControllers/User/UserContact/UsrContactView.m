//
//  UsrContactView.m
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"
#import "UsrContactView+Net.h"
#import "UsrContactFriendCell.h"



static const CGFloat kItemHeight = 60;


@interface UsrContactView ()<UITableViewDelegate, UITableViewDataSource>

@end


@implementation UsrContactView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = WCClear;
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.sectionFooterHeight = 0.1;
        self.sectionHeaderHeight = 0.1;
        
        [self registerNib:[UINib nibWithNibName:@"UsrContactFriendCell" bundle:nil] forCellReuseIdentifier:@"UsrContactFriendCellID"];
        
        
//        [self onNetGetFriendList];
        
        WCWeakSelf(self);
        [self onNetLoadLocalList:^{
           
            [weakself loadDataInMainThread];
        }];
    }
    return self;
}

- (void)loadDataInMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self reloadData];
    });
}

- (NSMutableArray *)sectionArray
{
    if (!_sectionArray)
    {
        _sectionArray = [NSMutableArray arrayWithCapacity:0];
        [_sectionArray addObject:@"个人信息"];
        [_sectionArray addObject:@"公司1"];
        [_sectionArray addObject:@"公司2"];
        [_sectionArray addObject:@"公司3"];
    }
    return _sectionArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section)
    {
        return 3;
    }
    
    if (self.dataArray.count &&
        self.dataArray[section])
        
        return [self.dataArray[section] count];
    else
        return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (section)
    {
        headView.frame = CGRectMake(0, 0, self.width, kItemHeight);
        

        UIImageView *iconImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(10, 10, 40, 40) ImageName:nil BgColor:WCBlue];
        [headView addSubview:iconImg];
        
        UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(60, 10, self.width - 70, 40) Text:self.sectionArray[section]];
        [headView addSubview:titleLabel];
    }
    
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsrContactFriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        if (self.dataArray.count &&
           self.dataArray[indexPath.section])
        {
            [friendCell configWithItem:nil itemText:self.dataArray[indexPath.section][indexPath.row]];
        }
    }
    
    return friendCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kItemHeight;
//    if (section)
//    {
//        return kItemHeight;
//    }
//    
//    return 0.01;    //第一组没有头视图
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
