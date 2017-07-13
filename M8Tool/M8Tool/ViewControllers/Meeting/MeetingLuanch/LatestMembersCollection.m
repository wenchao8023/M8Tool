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
        
        [self dataMembersArray];
        [self statusArray];
        [self reloadData];
    }
    return self;
}

- (NSMutableArray *)dataMembersArray
{
    if (!_dataMembersArray)
    {
        _dataMembersArray = [NSMutableArray arrayWithCapacity:0];
        [_dataMembersArray addObject:@"user1"];
        [_dataMembersArray addObject:@"user2"];
        [_dataMembersArray addObject:@"user3"];
        [_dataMembersArray addObject:@"user4"];
        [_dataMembersArray addObject:@"user5"];
        [_dataMembersArray addObject:@"user6"];
        [_dataMembersArray addObject:@"user7"];
        [_dataMembersArray addObject:@"user8"];
        [_dataMembersArray addObject:@"user9"];
        [_dataMembersArray addObject:@"user10"];
        [_dataMembersArray addObject:@"lcwyx1"];
        [_dataMembersArray addObject:@"lcwyx2"];
        [_dataMembersArray addObject:@"lcwyx3"];
        [_dataMembersArray addObject:@"lcwyx4"];
    }
    return _dataMembersArray;
}

- (NSMutableArray *)statusArray {
    if (!_statusArray) {
        NSMutableArray *statusArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.dataMembersArray.count; i++) {
            [statusArray addObject:@"0"];
        }
        _statusArray = statusArray;      
    }
    return _statusArray;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataMembersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingMembersCellID" forIndexPath:indexPath];

    [cell configLatestMembersWithNameStr:self.dataMembersArray[indexPath.row]
                              isSelected:[self.statusArray[indexPath.row] isEqualToString:@"1"] ? YES : NO
                            radiusBorder:kItemWidth / 2
     ];
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
        [self.WCDelegate LatestMembersCollectionDidSelectedMembers:@{self.dataMembersArray[indexPath.row] : self.statusArray[indexPath.row]}];
    }
    
    [collectionView reloadData];
}



- (void)syncDataMembersArrayWithIdentifier:(NSString *)identifier {
    if ([self.dataMembersArray containsObject:identifier]) {
        [self.statusArray replaceObjectAtIndex:[self.dataMembersArray indexOfObject:identifier] withObject:@"0"];
    }
    
    [self reloadData];
}

- (void)syncCurrentNumbers:(NSInteger)currentNumbers {
    self.currentMembers = currentNumbers;
}





@end
