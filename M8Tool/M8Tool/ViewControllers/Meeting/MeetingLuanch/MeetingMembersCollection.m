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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
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

- (void)setNumbersWithCurrentNumbers:(NSInteger)currenNumbers totalNumbers:(NSInteger)totalNumbers
{
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
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        
        [self registerNib:[UINib nibWithNibName:@"MeetingMembersCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingMembersCellID"];
        [self registerClass:[MembersCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID];
        
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
- (NSMutableArray *)dataMembersArray
{
    if (!_dataMembersArray)
    {
        _dataMembersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataMembersArray;
}

-(void)dealloc {
    
    [self removeObserver:self forKeyPath:@"dataMembersArray" context:NULL];
    [self removeObserver:self forKeyPath:@"contentSize" context:NULL];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
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

    if (self.dataMembersArray &&
        self.dataMembersArray.count)
    {   //数组中至少有一个元素
        if (indexPath.row < self.dataMembersArray.count)
        {
            M8MemberInfo *memberInfo = self.dataMembersArray[indexPath.row];
            
            [cell configMeetingMembersWithNameStr:memberInfo.nick
                                         isDeling:self.isDeling
                                     radiusBorder:kItemWidth / 2];
        }
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
                if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionDeletedMember:)])
                {
                    M8MemberInfo *info = self.dataMembersArray[indexPath.row];
                    
                    [self.WCDelegate MeetingMembersCollectionDeletedMember:info.uid];
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

- (void)inviteMembersFromContact
{
    if (self.dataMembersArray.count < self.totalNumbers)
    {
        //从通讯录选择成员
        M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
        if (!modelManger.inviteMemberArray.count)   //如果没有成员，则需要通知 tableview 中的代理，把自己加上
        {
            if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionCurrentMembers:)])
            {
                [self.WCDelegate MeetingMembersCollectionCurrentMembers:self.dataMembersArray];
            }
        }
        
        UserContactViewController *contactVC = [[UserContactViewController alloc] init];
        contactVC.contactType = ContactType_sel;
        contactVC.isExitLeftItem = YES;
        [[AppDelegate sharedAppDelegate] pushViewController:contactVC];
    }
    else
    {
        [AlertHelp alertWith:@"温馨提示"
                     message:[NSString stringWithFormat:@"最多只能邀请: %ld 人", (long)self.totalNumbers]
                   cancelBtn:@"确定"
                  alertStyle:UIAlertControllerStyleAlert
                cancelAction:nil];
    }
    
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    // 监听数组元素的变化
    if ([keyPath isEqualToString:@"dataMembersArray"])
    {
        if (!self.dataMembersArray.count)
        {
            self.isDeling = NO;
        }
        
        if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionCurrentMembers:)])
        {
            [self.WCDelegate MeetingMembersCollectionCurrentMembers:self.dataMembersArray];
        }   
    }
    
    // 监听 contentSize
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if ([self.WCDelegate respondsToSelector:@selector(MeetingMembersCollectionContentHeight:)])
        {
            [self.WCDelegate MeetingMembersCollectionContentHeight:self.contentSize.height];
        }
    }
}


#pragma mark - public function
// 同步从最近联系人发来的数据
- (void)syncDataMembersArrayWithDic:(NSDictionary *)memberInfo
{
    if (self.isDeling)
    {
        self.isDeling = NO;
    }
    
    M8MemberInfo *info  = [memberInfo objectForKey:@"memberInfo"];
    NSString     *statu = [memberInfo objectForKey:@"memberStatu"];
    
    if ([statu isEqualToString:@"1"])
    {
        [[self mutableArrayValueForKey:@"dataMembersArray"] addObject:info];
    }
    else
    {
        for (M8MemberInfo *member in self.dataMembersArray)
        {
            if ([member.uid isEqualToString:info.uid])
            {
                [[self mutableArrayValueForKey:@"dataMembersArray"] removeObject:member];
            }
        }
    }
    
    [self reloadData];
}

#pragma mark -0- 同步从通讯录选人模式下选择的成员
- (void)shouldReloadDataFromSelectContact:(TCIVoidBlock)succHandle
{
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    
    for (M8MemberInfo *info in modelManger.selectMemberArray)
    {
        [[self mutableArrayValueForKey:@"dataMembersArray"] addObject:info];
    }
    //操作成功，将信息回传给上一级去还原设置
    if (succHandle)
    {
        succHandle();
    }
    
    [self reloadData];
}


@end
