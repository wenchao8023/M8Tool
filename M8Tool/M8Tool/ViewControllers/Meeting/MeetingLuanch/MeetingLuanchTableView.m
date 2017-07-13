//
//  MeetingLuanchTableView.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchTableView.h"
#import "MeetingMembersCollection.h"
#import "LatestMembersCollection.h"
#import "MeetingLuanchCell.h"


#define kItemWidth (self.width - 60) / 5
#define kSectionHeight 40




///////////////////直播类型的时候--标题图片//////////////////////
#pragma mark - header image in live_type
@interface TBheaderView : UIImageView

@end


@implementation TBheaderView
- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:image];
    }
    return self;
}
@end
///////////////////////////////////////////////////







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



///////////////////tableView 的 tableFooterView///////////////////////////
#pragma mark - tableView >>>>>>>>>>> footerView: LatestMembersCollection + MeetingMembersCollection

@protocol TBFooterViewDelegate <NSObject>

- (void)TBFooterViewCurrentMembers:(NSArray *)currentMembers;

@end


@interface TBFooterView : UIView<MeetingMembersCollectionDelegate, LatestMembersCollectionDelegate>

@property (nonatomic, strong) LatestMembersCollection   *latestCollection;
@property (nonatomic, strong) MeetingMembersCollection  *membersCollection;

@property (nonatomic, weak) id WCDelegate;

@end


@implementation TBFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self membersCollection];
        self.membersCollection.WCDelegate   = self;
        
        [self latestCollection];
        self.latestCollection.WCDelegate    = self;
        
        
    }
    return self;
}

- (MeetingMembersCollection *)membersCollection {
    if (!_membersCollection) {
        CGRect membersFrame = self.bounds;
        membersFrame.size.height = kSectionHeight + kItemWidth;
        MeetingMembersCollection *membersCollection = [[MeetingMembersCollection alloc] initWithFrame:membersFrame
                                                                                 collectionViewLayout:[[MyFlowLayout alloc] initWithHeaderSize:CGSizeMake(self.width, kSectionHeight)
                                                                                                                                      itemSize:CGSizeMake(kItemWidth, kItemWidth)]];
        [self addSubview:(_membersCollection = membersCollection)];
    }
    return _membersCollection;
}

- (LatestMembersCollection *)latestCollection {
    if (!_latestCollection) {
        CGRect latestFrame = self.bounds;
        latestFrame.origin.y    = CGRectGetMaxY(self.membersCollection.frame);
        latestFrame.size.height -= CGRectGetMaxY(self.membersCollection.frame);
        LatestMembersCollection *latestCollection = [[LatestMembersCollection alloc] initWithFrame:latestFrame
                                                                                 collectionViewLayout:[[MyFlowLayout alloc] initWithHeaderSize:CGSizeMake(self.width, kSectionHeight)
                                                                                                                                      itemSize:CGSizeMake(kItemWidth, kItemWidth)]];
        [self addSubview:(_latestCollection = latestCollection)];
    }
    return _latestCollection;
}

/**
 *  设置预约会议视图
 *  隐藏最近联系人
 */
- (void)setOrderView {
    self.latestCollection.hidden = YES;
}

- (void)MeetingMembersCollectionDeletedMember:(NSString *)delNameStr {
    [self.latestCollection syncDataMembersArrayWithIdentifier:delNameStr];
}

- (void)MeetingMembersCollectionContentHeight:(CGFloat)contentHeight {
    
    // 改变设置顺序，修复出现视图重叠现象
    if (contentHeight < _membersCollection.height) {
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.membersCollection setHeight:contentHeight];
            
        } completion:^(BOOL finished) {
            if (finished) {
                [self.latestCollection setY:contentHeight];
                [self.latestCollection setHeight:self.height - contentHeight - kSectionHeight];
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self.latestCollection setHeight:self.height - contentHeight - kSectionHeight];
            [self.latestCollection setY:contentHeight];

        } completion:^(BOOL finished) {
            if (finished) {
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
- (void)MeetingMembersCollectionCurrentMembers:(NSArray *)currenMembers {
    [self.latestCollection syncCurrentNumbers:currenMembers.count];
    
    if ([self.WCDelegate respondsToSelector:@selector(TBFooterViewCurrentMembers:)]) {
        [self.WCDelegate TBFooterViewCurrentMembers:currenMembers];
    }
}



/**
 *  LatestMembersCollectionDelegate
 *
 *  @param memberInfo 点击最近联系人的信息
 */
- (void)LatestMembersCollectionDidSelectedMembers:(NSDictionary *)memberInfo
{
    WCLog(@"The Member %@'s statu is %@", [[memberInfo allKeys] firstObject], [[memberInfo allValues] firstObject]);
    [self.membersCollection syncDataMembersArrayWithDic:memberInfo];
}
@end
///////////////////////////////////////////////////




#pragma mark - main class
@interface MeetingLuanchTableView()<UITableViewDelegate, UITableViewDataSource, ModifyViewDelegate, TBFooterViewDelegate>



@property (nonatomic, strong) NSMutableArray *dataItemArray;
@property (nonatomic, strong) NSMutableArray *dataContentArray;

@property (nonatomic, strong) TBFooterView *tbFooterView;
@property (nonatomic, strong) TBheaderView *tbheaderView;

@end


@implementation MeetingLuanchTableView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
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
        
        self.tableFooterView = self.tbFooterView;
        
        
    }
    return self;
}

- (TBFooterView *)tbFooterView {
    if (!_tbFooterView) {
        CGRect footerFrame = self.bounds;
        footerFrame.size.height -= 89;
        
        _tbFooterView = [[TBFooterView alloc] initWithFrame:footerFrame];
        _tbFooterView.WCDelegate = self;
    }
    return _tbFooterView;
}

- (TBheaderView *)tbheaderView {
    if (!_tbheaderView) {
        CGRect frame = self.bounds;
        frame.size.height /= 2;
        _tbheaderView = [[TBheaderView alloc] initWithFrame:frame image:@"defaul_publishcover"];
    }
    return _tbheaderView;
}



- (NSMutableArray *)dataItemArray {
    if (!_dataItemArray) {
        _dataItemArray = [NSMutableArray arrayWithCapacity:0];
        [_dataItemArray addObjectsFromArray:@[@"会议主题", @"剩余分钟数"]];
    }
    return _dataItemArray;
}

- (NSMutableArray *)dataContentArray {
    if (!_dataContentArray) {
        _dataContentArray = [NSMutableArray arrayWithCapacity:0];
        [_dataContentArray addObjectsFromArray:@[@"木木的会议", @"600分钟"]];
    }
    return _dataContentArray;
}
    
- (void)reloadData {
    [super reloadData];
    
    NSString *topic = [self.dataContentArray firstObject];
    
    if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingTopic:)]) {
        [self.WCDelegate luanchTableViewMeetingTopic:topic];
    }
}

/**
 *  加载预约会议的数据
 */
- (void)reloadContentData {
    [self.dataItemArray removeAllObjects];
    [self.dataItemArray addObjectsFromArray:@[@"会议类型", @"会议主题", @"会议室预订",
                                              @"会议时间", @"预估时长", @"剩余分钟数"]];
    [self.dataContentArray removeAllObjects];
    [self.dataContentArray addObjectsFromArray:@[@"视频会议", @"林瑞的会议", @"深圳-轩辕会议室",
                                                 @"2017年5月7号 15:07", @"30分钟", @"600分钟"]];
    
    [self reloadData];
}


#pragma mark - setter
- (void)setIsHiddenFooter:(BOOL)isHiddenFooter {
    _isHiddenFooter = isHiddenFooter;
    self.tableFooterView.hidden = isHiddenFooter;
    self.tableHeaderView.hidden = !isHiddenFooter;
    
    if (isHiddenFooter) {
        if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingCoverImg:)]) {
            [self.WCDelegate luanchTableViewMeetingCoverImg:self.tbheaderView.image];
            self.tableHeaderView = [self tbheaderView];
        }
    }
    
        
}

- (void)setMaxMembers:(NSInteger)MaxMembers {
    _MaxMembers = MaxMembers;
    self.tbFooterView.membersCollection.totalNumbers = _MaxMembers;
    self.tbFooterView.latestCollection.totalNumbers  = _MaxMembers;
    
    if (_MaxMembers == 100) {   // 表示 预约会议
        [self reloadContentData];
        [self.tbFooterView setOrderView];
    }
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
                 content:self.dataContentArray[indexPath.row]
     ];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.isHiddenFooter)
        return [WCUIKitControl createViewWithFrame:CGRectZero BgColor:WCClear];
    else
        return [WCUIKitControl createViewWithFrame:CGRectZero BgColor:[UIColor colorWithRed:0.84 green:0.82 blue:0.79 alpha:1]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ModifyViewController *modifyVC = [[ModifyViewController alloc] init];
        modifyVC.naviTitle      = self.dataItemArray[indexPath.row];
        modifyVC.originContent  = self.dataContentArray[indexPath.row];
        modifyVC.modifyType     = Modify_text;
        modifyVC.WCDelegate     = self;
        [[AppDelegate sharedAppDelegate] pushViewController:modifyVC];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TBFooterViewDelegate 
- (void)TBFooterViewCurrentMembers:(NSArray *)currentMembers {
    if ([self.WCDelegate respondsToSelector:@selector(luanchTableViewMeetingCurrentMembers:)]) {
        [self.WCDelegate luanchTableViewMeetingCurrentMembers:currentMembers];
    }
}


#pragma mark - ModifyViewDelegate
- (void)modifyViewMofifyInfo:(NSDictionary *)modifyInfo {
    
    if ([[[modifyInfo allKeys] firstObject] isEqualToString:kModifyText]) {
        
        NSString *topic = [modifyInfo objectForKey:kModifyText];
        
        [self.dataContentArray replaceObjectAtIndex:0 withObject:topic];
    }
    
    
    [self reloadData];
}


@end
