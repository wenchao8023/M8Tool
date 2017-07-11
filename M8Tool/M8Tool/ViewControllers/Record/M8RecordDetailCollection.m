//
//  M8RecordDetailCollection.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecordDetailCollection.h"

#import "MeetingMembersCell.h"

#import "M8RecordDetailCollectionHeader.h"

#import "M8MeetListModel.h"



static NSString *CollectionHeaderID = @"M8RecordDetailCollectionID";

static CGFloat kRecordDetailHeaderHeight = 118.0;
#define kItemWidth (self.width - 60) / 5


@interface M8RecordDetailCollection ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *receiveArray;
@property (nonatomic, strong) NSMutableArray *rejectArray;
@property (nonatomic, strong) NSMutableArray *unresponseArray;

@end

@implementation M8RecordDetailCollection

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout dataModel:(M8MeetListModel *)model
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
        self.scrollEnabled = YES;
        
        [self registerNib:[UINib nibWithNibName:@"MeetingMembersCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingMembersCellID"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID];
        
        [self configDataModel:model];
    }
    
    return self;
}

- (NSMutableArray *)receiveArray
{
    if (!_receiveArray)
    {
        _receiveArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _receiveArray;
}

- (NSMutableArray *)rejectArray
{
    if (!_rejectArray)
    {
        _rejectArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _rejectArray;
}

- (NSMutableArray *)unresponseArray
{
    if (!_unresponseArray)
    {
        _unresponseArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _unresponseArray;
}


- (void)configDataModel:(M8MeetListModel *)model
{
    for (M8MeetMemberInfo *info in model.members)
    {
        if ([info.user isEqualToString:model.mainuser])
        {
            [self.receiveArray addObject:info];
        }
        else
        {
            switch ([info.statu intValue])
            {
                case 0: //未响应
                    [self.unresponseArray addObject:info];
                    break;
                case 1: //接听
                    [self.receiveArray addObject:info];
                    break;
                case 2: //拒绝
                    [self.rejectArray addObject:info];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.unresponseArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingMembersCellID"
                                                                         forIndexPath:indexPath];
    WCViewBorder_Radius(cell, kItemWidth / 2);
    
    if (self.unresponseArray &&
        self.unresponseArray.count)
    {
        M8MeetMemberInfo *info = self.unresponseArray[indexPath.row];
        [cell configRecordDetailWithNameStr:info.user];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID forIndexPath:indexPath];

        M8RecordDetailCollectionHeader *headerView = [[M8RecordDetailCollectionHeader alloc]
                                                      initWithFrame:CGRectMake(0, 0, self.width, kRecordDetailHeaderHeight)];
        [header addSubview:headerView];
        
        [headerView configRecNum:self.receiveArray.count
                          rejNum:self.rejectArray.count
                          unrNum:self.unresponseArray.count];
        
        
        return header;
    }
    return nil;
}
@end
