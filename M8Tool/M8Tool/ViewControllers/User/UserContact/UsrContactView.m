//
//  UsrContactView.m
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"
#import "UsrContactView+Net.h"
#import "UsrContactView+UI.h"
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
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];   // 不能使用CGRectZero，不起作用
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        
        self.clickSection = -1;
        [self sectionArray];
        [self statuArray];
        [self dataArray];
        
        WCWeakSelf(self);
        [self onNetLoadLocalList:^{
           
            [weakself loadDataInMainThread];
        }];
        
        [self onNetGetCompanyList:^{
            
            [weakself loadDataInMainThread];
        }];
    }
    return self;
}



- (NSMutableArray *)sectionArray
{
    if (!_sectionArray)
    {
        _sectionArray = [NSMutableArray arrayWithCapacity:0];
        [_sectionArray addObject:@"个人信息"];
    }
    return _sectionArray;
}

- (NSMutableArray *)statuArray
{
    if (!_statuArray)
    {
        NSMutableArray *statuArray = [NSMutableArray arrayWithCapacity:0];
//        for (id obj in self.sectionArray)
//        {
//            [statuArray addObject:@"0"];
//        }
        _statuArray = statuArray;
    }
    
    return _statuArray;
}

- (void)configStatuArray
{
    for (NSInteger i = 0; i < self.sectionArray.count; i++)
    {
        if (i < self.statuArray.count)
        {
            if (i == self.clickSection)
            {
                if ([self.statuArray[i] isEqualToString:@"0"])
                {
                    [self.statuArray replaceObjectAtIndex:i withObject:@"1"];
                }
                else
                {
                    [self.statuArray replaceObjectAtIndex:i withObject:@"0"];
                }
            }
        }
        else
        {
            [self.statuArray addObject:@"0"];
        }
        
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSArray *)actionArray
{
    if (!_actionArray)
    {
        _actionArray = @[@"onFriendListAction", @"onMobContactAction", @"onCommonGroupAction", @"onCommonContactAction"];
    }
    return _actionArray;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section)
    {
        if (section == self.sectionArray.count) //最后一分组
        {
            return 0;
        }
        else    //中间的公司信息
        {
            if ([self.statuArray[section] isEqualToString:@"0"])
            {
                if (self.dataArray.count > section)
                {
                    return [self.dataArray[section] count];
                }
            }
            else
            {
                return 0;
            }
        }
    }
    
    if (self.dataArray.count > section)    //第一分组信息
        
        return [self.dataArray[section] count];
    else
        return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.width, 0.01)];
    
    if (section)
    {
        if (section == self.sectionArray.count)
        {
            UIButton *createTeamBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(0, 10, self.width, 40) Target:self Action:@selector(onCreateTeamAction) Title:@"+创建团队"];
            createTeamBtn.titleLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
            [createTeamBtn setTitleColor:WCBlack forState:UIControlStateNormal];
            [headView addSubview:createTeamBtn];
        }
        else
        {
            M8CompanyInfo *cInfo = self.sectionArray[section];
            
            headView.frame = CGRectMake(0, 0, self.width, kItemHeight);
            headView.tag = section + 10;
            [headView setBackgroundColor:WCWhite];
            
            UIImageView *iconImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(10, 10, 40, 40) ImageName:nil BgColor:WCBlue];
            [headView addSubview:iconImg];
            
            UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(60, 10, self.width - 70 - 60, 40) Text:cInfo.cname];
            titleLabel.font = [UIFont systemFontOfSize:kAppLargeFontSize];
            titleLabel.numberOfLines = 1;
            [headView addSubview:titleLabel];
            
            
            NSString *btnStr = nil;
            
            if ([cInfo.uid isEqualToString:[[ILiveLoginManager getInstance] getLoginId]])
                btnStr = @"编辑";
            else
                btnStr = @"邀请";
            
            UIButton *mangerBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(self.width - 60, 10, 50, 40) Target:self Action:@selector(onMangerComAction) Title:btnStr];
            mangerBtn.titleLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
            [mangerBtn setTitleColor:WCBlack forState:UIControlStateNormal];
            [mangerBtn setBorder_left_color:WCLightGray width:1];
            [headView addSubview:mangerBtn];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderAction:)];
            [headView addGestureRecognizer:tap];
        }
    }
    
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsrContactFriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID"];
    
    if (!friendCell)
    {
        friendCell = [[[NSBundle mainBundle] loadNibNamed:@"UsrContactFriendCell" owner:nil options:nil] firstObject];
    }
    
    if (indexPath.section == 0) //第一分组信息
    {
        if (self.dataArray.count &&
           self.dataArray[indexPath.section])
        {
            [friendCell configWithItem:nil itemText:self.dataArray[indexPath.section][indexPath.row]];
        }
    }
    else if (indexPath.section == self.sectionArray.count)
    {
        NSAssert(1, @"程序正常运行时不能走到这");
    }
    else    //中间的部门信息
    {
        [friendCell configWithDepartmentItem:self.dataArray[indexPath.section][indexPath.row]];
    }
    
    return friendCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section)
    {
        return kItemHeight;
    }
    
    return 0.01;    //第一组没有头视图
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.sectionArray.count)
    {
        return 0.01;
    }
    return 10;
}


@end
