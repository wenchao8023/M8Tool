//
//  M8LuanchTableViewFooter.m
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LuanchTableViewFooter.h"
#import "MeetingMembersCollection.h"
#import "LatestMembersCollection.h"

#import "M8InviteModelManger.h"

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



@interface M8LuanchTableViewFooter ()<MeetingMembersCollectionDelegate, LatestMembersCollectionDelegate>

@property (nonatomic, strong) LatestMembersCollection   *latestCollection;
@property (nonatomic, strong) MeetingMembersCollection  *membersCollection;

@end



@implementation M8LuanchTableViewFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self membersCollection];
        self.membersCollection.WCDelegate   = self;
        
        [self latestCollection];
        self.latestCollection.WCDelegate    = self;
    }
    
    return self;
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
        [self addSubview:(_membersCollection = membersCollection)];
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
        [self addSubview:(_latestCollection = latestCollection)];
    }
    return _latestCollection;
}

/**
 *  设置预约会议视图
 *  隐藏最近联系人
 */
- (void)setOrderView
{
    self.latestCollection.hidden = YES;
}

- (void)setTotalNumbers:(NSInteger)totalNumbers
{
    _totalNumbers = totalNumbers;
    
    self.membersCollection.totalNumbers = totalNumbers;
    self.latestCollection.totalNumbers  = totalNumbers;
    
    if (totalNumbers == 100)    // 表示 预约会议
    {
        [self setOrderView];
    }
}


#pragma mark - delegates
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
    [self.latestCollection syncCurrentNumbers:currenMembers.count];
    
    //保存发起 call 时邀请的成员
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:currenMembers];
    
    M8MemberInfo *selfInfo = [[M8MemberInfo alloc] init];
    selfInfo.uid = [M8UserDefault getLoginId];
    selfInfo.nick = [M8UserDefault getLoginNick];
    [tempArr insertObject:selfInfo atIndex:0];
    
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    [modelManger updateInviteMemberArray:tempArr];
    
    if ([self.WCDelegate respondsToSelector:@selector(TBFooterViewCurrentMembers:)])
    {
        NSMutableArray *uidArr = [NSMutableArray arrayWithCapacity:0];
        
        for (M8MemberInfo *info in currenMembers)
        {
            [uidArr addObject:info.uid];
        }
        
        [self.WCDelegate TBFooterViewCurrentMembers:uidArr];
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
