//
//  MeetingLuanchTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchTableView.h"
#import "M8LuanchTableViewHeader.h"
#import "M8LuanchTableViewFooter.h"
#import "MeetingLuanchCell.h"



@interface MeetingLuanchTableView()<UITableViewDelegate, UITableViewDataSource, ModifyViewDelegate, TBFooterViewDelegate>


@property (nonatomic, strong) NSMutableArray *dataItemArray;
@property (nonatomic, strong) NSMutableArray *dataContentArray;

@property (nonatomic, strong) M8LuanchTableViewHeader *tbHeaderView;
@property (nonatomic, strong) M8LuanchTableViewFooter *tbFooterView;

@end


@implementation MeetingLuanchTableView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.01)];
        self.backgroundColor = WCClear;
        self.scrollEnabled = NO;
        self.delegate   = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableFooterView = self.tbFooterView;
        
        
    }
    return self;
}

- (M8LuanchTableViewFooter *)tbFooterView
{
    if (!_tbFooterView)
    {
        CGRect footerFrame = self.bounds;
        footerFrame.size.height -= 89;
        
        _tbFooterView = [[M8LuanchTableViewFooter alloc] initWithFrame:footerFrame];
        _tbFooterView.WCDelegate = self;
    }
    return _tbFooterView;
}

- (M8LuanchTableViewHeader *)tbHeaderView
{
    if (!_tbHeaderView)
    {
        CGRect frame = self.bounds;
        frame.size.height /= 2;
        _tbHeaderView = [[M8LuanchTableViewHeader alloc] initWithFrame:frame image:@"defaul_publishcover"];
    }
    return _tbHeaderView;
}



- (NSMutableArray *)dataItemArray
{
    if (!_dataItemArray)
    {
        _dataItemArray = [NSMutableArray arrayWithCapacity:0];
        [_dataItemArray addObjectsFromArray:@[@"会议主题", @"剩余分钟数"]];
    }
    return _dataItemArray;
}

- (NSMutableArray *)dataContentArray
{
    if (!_dataContentArray)
    {
        _dataContentArray = [NSMutableArray arrayWithCapacity:0];
        [_dataContentArray addObjectsFromArray:@[@"木木的会议", @"600分钟"]];
    }
    return _dataContentArray;
}
    
- (void)reloadData
{
    [super reloadData];
    
    NSString *topic = [self.dataContentArray firstObject];
    
    if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingTopic:)])
    {
        [self.WCDelegate luanchTableViewMeetingTopic:topic];
    }
}

/**
 *  加载预约会议的数据
 */
- (void)reloadContentData
{
    [self.dataItemArray removeAllObjects];
    [self.dataItemArray addObjectsFromArray:@[@"会议类型", @"会议主题", @"会议室预订",
                                              @"会议时间", @"预估时长", @"剩余分钟数"]];
    [self.dataContentArray removeAllObjects];
    [self.dataContentArray addObjectsFromArray:@[@"视频会议", @"林瑞的会议", @"深圳-轩辕会议室",
                                                 @"2017年5月7号 15:07", @"30分钟", @"600分钟"]];
    
    [self reloadData];
}


#pragma mark - setter
- (void)setIsHiddenFooter:(BOOL)isHiddenFooter
{
    _isHiddenFooter = isHiddenFooter;
    self.tableFooterView.hidden = isHiddenFooter;
    self.tableHeaderView.hidden = !isHiddenFooter;
    
    if (isHiddenFooter)
    {
        if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingCoverImg:)])
        {
            [self.WCDelegate luanchTableViewMeetingCoverImg:self.tbHeaderView.image];
            self.tableHeaderView = [self tbHeaderView];
        }
    }
    
        
}

- (void)setMaxMembers:(NSInteger)MaxMembers
{
    _MaxMembers = MaxMembers;
    
    [self.tbFooterView setTotalNumbers:_MaxMembers];
    
    if (_MaxMembers == 100)
    {   // 表示 预约会议
        [self reloadContentData];
    }
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
    }
    [cell configWithItem:self.dataItemArray[indexPath.row]
                 content:self.dataContentArray[indexPath.row]
     ];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.isHiddenFooter)
        return [WCUIKitControl createViewWithFrame:CGRectZero BgColor:WCClear];
    else
        return [WCUIKitControl createViewWithFrame:CGRectZero BgColor:[UIColor colorWithRed:0.84 green:0.82 blue:0.79 alpha:1]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ModifyViewController *modifyVC = [[ModifyViewController alloc] init];
        modifyVC.naviTitle      = self.dataItemArray[indexPath.row];
        modifyVC.originContent  = self.dataContentArray[indexPath.row];
        modifyVC.modifyType     = Modify_text;
        modifyVC.WCDelegate     = self;
        [[AppDelegate sharedAppDelegate] pushViewController:modifyVC];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - delegates
#pragma mark -- TBFooterViewDelegate
- (void)TBFooterViewCurrentMembers:(NSArray *)currentMembers
{
    if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingCurrentMembers:)])
    {
        [self.WCDelegate luanchTableViewMeetingCurrentMembers:currentMembers];
    }
}


#pragma mark -- ModifyViewDelegate
- (void)modifyViewMofifyInfo:(NSDictionary *)modifyInfo
{
    if ([[[modifyInfo allKeys] firstObject] isEqualToString:kModifyText])
    {
        NSString *topic = [modifyInfo objectForKey:kModifyText];
        
        [self.dataContentArray replaceObjectAtIndex:0 withObject:topic];
    }
    
    
    [self reloadData];
}


@end
