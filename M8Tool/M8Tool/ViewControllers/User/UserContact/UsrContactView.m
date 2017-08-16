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

@property (nonatomic, strong) NSArray *headSectionImgArray;


@end


@implementation UsrContactView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style contactType:(ContactType)contactType
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.contactType = contactType;
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = WCClear;
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];   // 不能使用CGRectZero，不起作用
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.showsVerticalScrollIndicator = NO;
        
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
        _statuArray = statuArray;
    }
    
    return _statuArray;
}

/**
 如果是创建公司之后则需要保存上一次点击头部分组的分组状态，防止刷新的时候被修改
 使用策略 ： 将 clickSection = -1，还原点击值
 */

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
        _actionArray = @[@"onFriendListAction", @"onMobContactAction"];
    }
    return _actionArray;
}

- (NSArray *)headSectionImgArray
{
    if (!_headSectionImgArray)
    {
        _headSectionImgArray = @[@"user_friendIcon", @"user_mobContactIcon"];
    }
    
    return _headSectionImgArray;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
//    return self.sectionArray.count + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section)
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
        M8CompanyInfo *cInfo = self.sectionArray[section];
        
        headView.frame = CGRectMake(0, 0, self.width, kItemHeight);
        headView.tag = section + 10;
        [headView setBackgroundColor:WCWhite];
        
        UIImageView *iconImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(10, 15, 30, 30) ImageName:nil BgColor:WCClear];
        [headView addSubview:iconImg];
        
        if ([self.statuArray[section] isEqualToString:@"0"])
        {
            [iconImg setImage:[UIImage imageNamed:@"user_unFolder"]];
        }
        else
        {
            [iconImg setImage:[UIImage imageNamed:@"user_folder"]];
        }
        
        UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(60, 10, self.width - 70 - 60, 40) Text:cInfo.cname];
        titleLabel.font = [UIFont systemFontOfSize:kAppLargeFontSize];
        titleLabel.numberOfLines = 1;
        [headView addSubview:titleLabel];
        
        
        NSString *btnStr = nil;
        
        if ([cInfo.uid isEqualToString:[M8UserDefault getLoginId]])
            btnStr = @"管理";
        else
            btnStr = @"邀请";
        
        UIButton *mangerBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(self.width - 60, 10, 50, 40) Target:self Action:@selector(onMangerComAction:) Title:btnStr];
        mangerBtn.titleLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
        mangerBtn.tag = 50 + section;
        [mangerBtn setTitleColor:WCBlack forState:UIControlStateNormal];
        [mangerBtn setBorder_left_color:WCLightGray width:1];
        [headView addSubview:mangerBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderAction:)];
        [headView addGestureRecognizer:tap];
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
            if (indexPath.row == 0)
            {
                if ([M8UserDefault getNewFriendNotify])
                {
                    [friendCell configWithItem:@"user_friendIconNotify" itemText:self.dataArray[indexPath.section][indexPath.row]];
                }
                else
                {
                    [friendCell configWithItem:@"user_friendIcon" itemText:self.dataArray[indexPath.section][indexPath.row]];
                }
            }
            else
            {
                [friendCell configWithItem:@"user_mobContactIcon" itemText:self.dataArray[indexPath.section][indexPath.row]];
            }
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
    return 10;
}

#pragma mark -- 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onDidSelectAtIndex:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 滑动删除cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section &&
        indexPath.section < self.sectionArray.count)
    {
        //如果不是公司创建者，则不会让用户有删除的权利
        M8CompanyInfo *cInfo = self.sectionArray[indexPath.section];
        if (![cInfo.uid isEqualToString:[M8UserDefault getLoginId]])
        {
            return NO;
        }
    }
    
    
    if (self.contactType == ContactType_sel ||
        self.contactType == ContactType_invite)
    {
        return NO;
    }
    
    if (indexPath.row == 0)
    {
        return NO;
    }
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        WCWeakSelf(self);
        [self onNetDeleteDepartmentForIndexPath:indexPath succ:^{
            
            [weakself onNetGetCompanyList:^{
                
                [weakself loadDataInMainThread];
            }];
        }];
    }
}



#pragma mark - onSubviewAddAction
- (void)onSubviewAddAction
{
    [self onCreateTeamAction];
}

@end
