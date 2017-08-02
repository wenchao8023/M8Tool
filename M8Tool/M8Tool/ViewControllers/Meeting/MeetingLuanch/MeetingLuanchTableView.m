//
//  MeetingLuanchTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchTableView.h"
#import "MeetingLuanchCell.h"
#import "MeetingMembersCollection.h"
#import "LatestMembersCollection.h"




#define kItemWidth (self.width - 60) / 5
#define kSectionHeight 40

/*****************设置 UICollectionViewFlowLayout *************************/
#pragma mark - CollectionView >>>>>>>>>>>>>>  flowLayout
@interface MyFlowLayout : UICollectionViewFlowLayout


@end

@implementation MyFlowLayout

- (instancetype)initWithHeaderSize:(CGSize)headerSize itemSize:(CGSize)itemSize
{
    if (self = [super init])
    {
        if (IOS_SYSTEM_VERSION >= 9.0)
        {
            self.sectionHeadersPinToVisibleBounds = YES;
        }
        
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.headerReferenceSize = headerSize;
        self.itemSize = itemSize;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
@end
/**************************************************************************/


/********************* M8LuanchTableViewHeader ****************************/
@interface M8LuanchTableViewHeader : UIImageView

@end

@implementation M8LuanchTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image
{
    if (self = [super initWithFrame:frame])
    {
        self.image = [UIImage imageNamed:image];
        self.userInteractionEnabled = YES;
        
        
    }
    return self;
}

@end
/**************************************************************************/


/********************* M8LuanchTableViewFooter ****************************/
@interface M8LuanchTableViewFooter : UIView

@end

@implementation M8LuanchTableViewFooter

@end
/**************************************************************************/


@interface MeetingLuanchTableView()<UITableViewDelegate, UITableViewDataSource, ModifyViewDelegate, MeetingMembersCollectionDelegate, LatestMembersCollectionDelegate>


@property (nonatomic, strong) NSMutableArray *dataItemArray;
@property (nonatomic, strong) NSMutableArray *dataContentArray;

@property (nonatomic, strong) M8LuanchTableViewHeader *tbHeaderView;
@property (nonatomic, strong) M8LuanchTableViewFooter *tbFooterView;

@property (nonatomic, strong) LatestMembersCollection   *latestCollection;
@property (nonatomic, strong) MeetingMembersCollection  *membersCollection;

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
        
        [self membersCollection];
        [self latestCollection];
        
        self.tableFooterView = self.tbFooterView;
        
        
    }
    return self;
}

- (M8LuanchTableViewHeader *)tbHeaderView
{
    if (!_tbHeaderView)
    {
        CGRect frame = self.bounds;
        frame.size.height = frame.size.width * 222 / 375;
        _tbHeaderView = [[M8LuanchTableViewHeader alloc] initWithFrame:frame image:@"M8_6"];
    }
    return _tbHeaderView;
}

- (M8LuanchTableViewFooter *)tbFooterView
{
    if (!_tbFooterView)
    {
        CGRect footerFrame = self.bounds;
        footerFrame.size.height -= 89;
        
        _tbFooterView = [[M8LuanchTableViewFooter alloc] initWithFrame:footerFrame];
//        _tbFooterView.WCDelegate = self;
    }
    return _tbFooterView;
}

- (MeetingMembersCollection *)membersCollection
{
    if (!_membersCollection)
    {
        CGRect membersFrame = self.bounds;
        membersFrame.size.height = kSectionHeight + kItemWidth;
        MeetingMembersCollection *membersCollection = [[MeetingMembersCollection alloc] initWithFrame:membersFrame
                                                                                 collectionViewLayout:[[MyFlowLayout alloc] initWithHeaderSize:CGSizeMake(self.width, kSectionHeight)
                                                                                                                                      itemSize:CGSizeMake(kItemWidth, kItemWidth)]];
        membersCollection.WCDelegate = self;
        [self.tbFooterView addSubview:(_membersCollection = membersCollection)];
    }
    return _membersCollection;
}

- (LatestMembersCollection *)latestCollection
{
    if (!_latestCollection)
    {
        CGRect latestFrame = self.bounds;
        latestFrame.origin.y    = CGRectGetMaxY(self.membersCollection.frame);
        latestFrame.size.height -= CGRectGetMaxY(self.membersCollection.frame);
        LatestMembersCollection *latestCollection = [[LatestMembersCollection alloc] initWithFrame:latestFrame
                                                                              collectionViewLayout:[[MyFlowLayout alloc] initWithHeaderSize:CGSizeMake(self.width, kSectionHeight)
                                                                                                                                   itemSize:CGSizeMake(kItemWidth, kItemWidth)]];
        latestCollection.WCDelegate = self;
        [self.tbFooterView addSubview:(_latestCollection = latestCollection)];
    }
    return _latestCollection;
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
        NSString *topic = [NSString stringWithFormat:@"%@的会议", [M8UserDefault getLoginNick]];
        [_dataContentArray addObjectsFromArray:@[topic, @"600分钟"]];
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
    
    
    [self.dataContentArray addObjectsFromArray:@[@"视频会议", @"会议主题", @"会议室",
                                                 [self getCurrentTime], @"30分钟", @"600分钟"]];
    
    [self reloadData];
}

-(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate  date]];
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
    
    self.membersCollection.totalNumbers = MaxMembers;
    self.latestCollection.totalNumbers  = MaxMembers;
    
    
    if (_MaxMembers == 100)
    {   // 表示 预约会议
        self.latestCollection.hidden = YES;
        
        [self reloadContentData];
    }
}


/**
 获取到了从通讯录选人模式下返回的消息，准备重新组装数据
 应该将消息传给 参会人员 去处理
 */
- (void)shouldReloadDataFromSelectContact:(M8VoidBlock)succHandle
{
    [self.membersCollection shouldReloadDataFromSelectContact:succHandle];
}

/**
 获取立即发起会议的消息
 如果是结束会议然后立即发起，这个时候 inviteArray中没有数据，需要重新加载数据
 */
- (void)loadDataWithLuanchCall
{
    M8InviteModelManger *inviteModelManger = [M8InviteModelManger shareInstance];
    
    if (!inviteModelManger.inviteMemberArray.count)
    {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.membersCollection getMembersArray]];
        
        M8MemberInfo *selfInfo = [[M8MemberInfo alloc] init];
        selfInfo.uid = [M8UserDefault getLoginId];
        selfInfo.nick = [M8UserDefault getLoginNick];
        [tempArr insertObject:selfInfo atIndex:0];
        
        [inviteModelManger updateInviteMemberArray:tempArr];
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

#pragma mark -- MeetingMembersCollectionDelegate
- (void)MeetingMembersCollectionDeletedMember:(NSString *)delNameStr
{
    [self.latestCollection syncDataMembersArrayWithIdentifier:delNameStr];
}

- (void)MeetingMembersCollectionContentHeight:(CGFloat)contentHeight
{
    // 改变设置顺序，修复出现视图重叠现象
    if (contentHeight < _membersCollection.height)
    {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.membersCollection setHeight:contentHeight];
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                [self.latestCollection setY:contentHeight];
                [self.latestCollection setHeight:self.height - contentHeight - kSectionHeight];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.latestCollection setHeight:self.height - contentHeight - kSectionHeight];
            [self.latestCollection setY:contentHeight];
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                [self.membersCollection setHeight:contentHeight];
            }
        }];
    }
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.latestCollection setY:contentHeight];
        [self.latestCollection setHeight:self.height - contentHeight - kSectionHeight];
        
    } completion:nil];
}


/**
 返回当前选中的成员给 tableView
 
 @param currenMembers 当前的成员
 */
- (void)MeetingMembersCollectionCurrentMembers:(NSArray *)currenMembers
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:currenMembers];
    
    M8MemberInfo *selfInfo = [[M8MemberInfo alloc] init];
    selfInfo.uid = [M8UserDefault getLoginId];
    selfInfo.nick = [M8UserDefault getLoginNick];
    [tempArr insertObject:selfInfo atIndex:0];
    
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    [modelManger updateInviteMemberArray:tempArr];
    
    [self.latestCollection syncCurrentNumbers:currenMembers.count];
    
    //保存发起 call 时邀请的成员，对于自己的信息只记录在单例，不返回给视图
    //如果保存在了 currentMmebers 中，则会导致显示参会人员会自动添加自己
    //所以在组装发起会议成员时，将 self.uid 放在最前面，这里对应的保存在最前面
    

    if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingCurrentMembers:)])
    {
        NSMutableArray *uidArr = [NSMutableArray arrayWithCapacity:0];

        for (M8MemberInfo *info in currenMembers)
        {
            [uidArr addObject:info.uid];
        }
        
        [self.WCDelegate luanchTableViewMeetingCurrentMembers:uidArr];
    }
}

#pragma mark -- LatestMembersCollectionDelegate
/**
 *  LatestMembersCollectionDelegate
 *
 *  @param memberInfo 点击最近联系人的信息
 {
 key : memberInfo,  value : M8MemberInfo;
 key : memberStatu, value : @"1"-表示选中 @"0"-表示反选
 }
 */
- (void)LatestMembersCollectionDidSelectedMembers:(NSDictionary *)memberInfo
{
    WCLog(@"The Member %@'s statu is %@", [memberInfo objectForKey:@"memberInfo"], [memberInfo objectForKey:@"memberStatu"]);
    [self.membersCollection syncDataMembersArrayWithDic:memberInfo];
}

@end
