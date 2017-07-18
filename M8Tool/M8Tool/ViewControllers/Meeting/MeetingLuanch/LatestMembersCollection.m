//
//  LatestMembersCollection.m
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "LatestMembersCollection.h"
#import "MeetingMembersCell.h"


#define kItemWidth (self.width - 60) / 5


static NSString *CollectionHeaderID = @"LatestMembersCollectionHeaderID";



///////////////////////////////////////////////////////////////
@interface LatestCollectionHeader : UICollectionReusableView

@end

@implementation LatestCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WCBgColor;
        UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(20, 0, 80, 40)
                                                              Text:@"最近联系人"
                                                          FontSize:kAppMiddleFontSize
                                                           BgColor:WCClear];
        [self addSubview:titleLabel];
    }
    return self;
}
@end
///////////////////////////////////////////////////////////////






@interface LatestMembersCollection ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataMembersArray;

@property (nonatomic, strong) NSMutableArray *statusArray;


/**
 记录参会人员中的人数，不代表自己这边选中的人数
 */
@property (nonatomic, assign) NSInteger currentMembers;

@end




@implementation LatestMembersCollection

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
        self.scrollEnabled = YES;
        
        [self registerNib:[UINib nibWithNibName:@"MeetingMembersCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingMembersCellID"];
        [self registerClass:[LatestCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID];

        [self onNetLoadLatestContact];
    }
    return self;
}

- (NSMutableArray *)dataMembersArray
{
    if (!_dataMembersArray)
    {
        _dataMembersArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataMembersArray;
}

- (NSMutableArray *)statusArray
{
    if (!_statusArray)
    {
        NSMutableArray *statusArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.dataMembersArray.count; i++)
        {
            [statusArray addObject:@"0"];
        }
        _statusArray = statusArray;      
    }
    return _statusArray;
}


- (void)onNetLoadLatestContact
{
    __block RecentlyContactResponseData *responseData = nil;
    WCWeakSelf(self);
    RecentlyContactRequest *recRequset = [[RecentlyContactRequest alloc] initWithHandler:^(BaseRequest *request) {
        
         responseData = (RecentlyContactResponseData *)request.response.data;
        [weakself loadMembers:responseData.nearusers];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    recRequset.token = [AppDelegate sharedAppDelegate].token;
    recRequset.uid   = [M8UserDefault getLoginId];
    [[WebServiceEngine sharedEngine] AFAsynRequest:recRequset];
}

- (void)loadMembers:(NSArray *)members
{
    for (NSDictionary *dic in members)
    {
        M8MemberInfo *info = [[M8MemberInfo alloc] init];
        [info setValuesForKeysWithDictionary:dic];
        [self.dataMembersArray addObject:info];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self reloadData];
    });
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMembersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingMembersCellID" forIndexPath:indexPath];

    if (self.dataMembersArray.count)
    {
        M8MemberInfo *memberInfo = self.dataMembersArray[indexPath.row];
        
        [cell configLatestMembersWithNameStr:memberInfo.nick
                                  isSelected:[self.statusArray[indexPath.row] isEqualToString:@"1"] ? YES : NO
                                radiusBorder:kItemWidth / 2
         ];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        LatestCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             withReuseIdentifier:CollectionHeaderID
                                                                                    forIndexPath:indexPath];
        return header;
    }
    return nil;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.statusArray[indexPath.row] isEqualToString:@"1"])
    {
        [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    else
    {
        if (self.currentMembers < self.totalNumbers)
        {
            [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
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
    
    if ([self.WCDelegate respondsToSelector:@selector(LatestMembersCollectionDidSelectedMembers:)])
    {
        [self.WCDelegate LatestMembersCollectionDidSelectedMembers:@{
                                                                     @"memberInfo"  : self.dataMembersArray[indexPath.row],
                                                                     @"memberStatu" : self.statusArray[indexPath.row]
                                                                     }
         ];
    }
    
    [collectionView reloadData];
}


//同步参会人员中被删除的成员信息
- (void)syncDataMembersArrayWithIdentifier:(NSString *)identifier
{
    for (M8MemberInfo *info in self.dataMembersArray)
    {
        if ([info.uid isEqualToString:identifier])
        {
            [self.statusArray replaceObjectAtIndex:[self.dataMembersArray indexOfObject:info] withObject:@"0"];
        }
    }
    
    [self reloadData];
}

- (void)syncCurrentNumbers:(NSInteger)currentNumbers
{
    self.currentMembers = currentNumbers;
}


@end
