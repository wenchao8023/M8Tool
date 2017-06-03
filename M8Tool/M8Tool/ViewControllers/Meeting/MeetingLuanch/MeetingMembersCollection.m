//
//  MeetingMembersCollection.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingMembersCollection.h"
#import "MeetingMembersCell.h"

#import "UserContactViewController.h"


#define kItemWidth (self.width - 60) / 5


static NSString *CollectionHeaderID = @"MeetingMembersCollectionHeaderID";





///////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - MembersCollectionHeader
@interface MembersCollectionHeader : UICollectionReusableView

@end

@implementation MembersCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(20, 0, 80, 40)
                                                              Text:@"参会人员"
                                                          FontSize:kAppMiddleFontSize
                                                           BgColor:WCClear];
        [self addSubview:titleLabel];
        
        CGFloat x = CGRectGetMaxX(titleLabel.frame);
        
        UILabel *numbersLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(x, 0, SCREEN_WIDTH - x - 20, 40)
                                                                Text:@""
                                                            FontSize:kAppMiddleFontSize
                                                       TextAlignment:0
                                                           TextColor:[UIColor colorWithRed:0.27 green:0.48 blue:0.45 alpha:1]
                                                             BgColor:WCClear];
        numbersLabel.tag = 64;
        [self addSubview:numbersLabel];
    }
    return self;
}

- (void)setNumbersWithCurrentNumbers:(NSInteger)currenNumbers totalNumbers:(NSInteger)totalNumbers {
    UILabel *numbersLabel = [self viewWithTag:64];
    NSString *textStr = [NSString stringWithFormat:@"%ld/%ld（最多可邀请%ld人）", (long)currenNumbers, (long)totalNumbers, (long)totalNumbers];
    [numbersLabel setAttributedText:[CommonUtil customAttString:textStr fontSize:kAppMiddleFontSize]];
}

@end
#pragma mark -
///////////////////////////////////////////////////////////////




#pragma mark - MeetingMembersCollection
@interface MeetingMembersCollection ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataMembersArray;

@property (nonatomic, assign) BOOL isDeling;


@end




@implementation MeetingMembersCollection


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerNib:[UINib nibWithNibName:@"MeetingMembersCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingMembersCellID"];
        [self registerClass:[MembersCollectionHeader class]
 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:CollectionHeaderID];
        
        [self addObserver:self forKeyPath:@"dataMembersArray" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}


/**
 * 对于参会成员数据处理
 *  不会将最后两个 item 元素添加进数组
 *  只保存参会成员信息
 *
 *  刚进来的时候数组是空的，用户可以选择最近联系人中的元素添加，也可以选择通讯录中的人来添加
 */
- (NSMutableArray *)dataMembersArray {
    if (!_dataMembersArray) {
        _dataMembersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataMembersArray;
}

-(void)dealloc {
    
    [self removeObserver:self forKeyPath:@"dataMembersArray" context:NULL];
    [self removeObserver:self forKeyPath:@"contentSize" context:NULL];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataMembersArray &&
        self.dataMembersArray.count)
    {  //数组中至少有一个元素
        return self.dataMembersArray.count + 2;
    }
    else
    {  // 数组中没有元素，只显示一个添加按钮
        return 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MeetingMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingMembersCellID" forIndexPath:indexPath];
    WCViewBorder_Radius(cell, kItemWidth / 2);
    cell.backgroundColor = [UIColor colorWithRed:0.05 green:0.43 blue:0.4 alpha:1];
    if (self.dataMembersArray &&
        self.dataMembersArray.count)
    {   //数组中至少有一个元素
        if (indexPath.row < self.dataMembersArray.count)
            [cell configMeetingMembersWithNameStr:self.dataMembersArray[indexPath.row] isDeling:self.isDeling];
        else if (indexPath.row == self.dataMembersArray.count)
            [cell configMeetingMembersWithImageStr:@"addMember"];
        else
            [cell configMeetingMembersWithImageStr:@"delMember"];
    }
    else
    {  // 数组中没有元素，只显示一个添加按钮
        [cell configMeetingMembersWithImageStr:@"addMember"];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MembersCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             withReuseIdentifier:CollectionHeaderID
                                                                                    forIndexPath:indexPath];
        [header setNumbersWithCurrentNumbers:self.dataMembersArray.count
                                totalNumbers:self.totalNumbers];
        return header;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataMembersArray &&
        self.dataMembersArray.count)    //数组中至少有一个元素
    {
        if (indexPath.row < self.dataMembersArray.count)    // 选择成员
        {
            if (self.isDeling)  // 正在删除中
            {
                if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionSelectedMembers:)]) {
                    [self.WCDelegate MeetingMembersCollectionSelectedMembers:self.dataMembersArray[indexPath.row]];
                }
                [[self mutableArrayValueForKey:@"dataMembersArray"] removeObjectAtIndex:indexPath.row];
            }
        }
        else if (indexPath.row == self.dataMembersArray.count)   // 选择添加
        {
            self.isDeling = NO;
            [self inviteMembersFromContact];
        }
        else    //选择删除
        {
            self.isDeling = !self.isDeling;
        }
    }
    else    // 数组中没有元素，只显示一个添加按钮
    {
        [self inviteMembersFromContact];
    }

    [collectionView reloadData];
}

- (void)inviteMembersFromContact {
    if (self.dataMembersArray.count < self.totalNumbers)
    {
        UserContactViewController *contactVC = [[UserContactViewController alloc] init];
        contactVC.contactType = ContactType_sel;
        contactVC.isExitLeftItem = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:contactVC];
    }
    else
    {
        [AppDelegate showAlertWithTitle:@"温馨提示"
                                message:[NSString stringWithFormat:@"最多只能邀请: %ld 人", (long)self.totalNumbers]
                                okTitle:@"确定"
                            cancelTitle:nil
                                     ok:nil
                                 cancel:nil];
    }
    
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 监听数组元素的变化
    if ([keyPath isEqualToString:@"dataMembersArray"]) {
        WCLog(@"dataMembersArray is changing");
        
        if (!self.dataMembersArray.count) {
            self.isDeling = NO;
        }
        
        if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionCurrentMembers:)]) {
            [self.WCDelegate MeetingMembersCollectionCurrentMembers:self.dataMembersArray.count];
        }
    }
    
    // 监听 contentSize
    if ([keyPath isEqualToString:@"contentSize"]) {
        if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionContentHeight:)]) {
            [self.WCDelegate MeetingMembersCollectionContentHeight:self.contentSize.height];
        }
    }
}


#pragma mark - public function
// 同步从最近联系人发来的数据
- (void)syncDataMembersArrayWithDic:(NSDictionary *)memberInfo {
    
    if (self.isDeling) {
        self.isDeling = NO;
    }
    
    NSString *identifier    = [[memberInfo allKeys] firstObject];
    NSString *statu         = [[memberInfo allValues] firstObject];
    if ([statu isEqualToString:@"1"]) {
        [[self mutableArrayValueForKey:@"dataMembersArray"] addObject:identifier];
    }
    else {
        if ([self.dataMembersArray containsObject:identifier]) {
            [[self mutableArrayValueForKey:@"dataMembersArray"] removeObject:identifier];
        }
    }
    
    [self reloadData];
}



@end
