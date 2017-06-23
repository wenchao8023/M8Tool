//
//  RecordDetailCollection.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordDetailCollection.h"

#import "MeetingMembersCell.h"

#import "RecordDetailCollectionHeader.h"

static NSString *CollectionHeaderID = @"RecordDetailCollectionID";

static CGFloat kRecordDetailHeaderHeight = 118.0;
#define kItemWidth (self.width - 60) / 5


@interface RecordDetailCollection ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RecordDetailCollection

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = WCClear;
        self.delegate   = self;
        self.dataSource = self;
        self.scrollEnabled = YES;
        
        [self registerNib:[UINib nibWithNibName:@"MeetingMembersCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingMembersCellID"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        _dataArray = dataArray;
    }
    return _dataArray;
}

- (void)configDataArray:(NSArray *)array {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self reloadData];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeetingMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingMembersCellID" forIndexPath:indexPath];
    WCViewBorder_Radius(cell, kItemWidth / 2);
    [cell configRecordDetailWithNameStr:self.dataArray[indexPath.row]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID forIndexPath:indexPath];

        RecordDetailCollectionHeader *headerView = [[RecordDetailCollectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.width, kRecordDetailHeaderHeight)];
        [header addSubview:headerView];
        [headerView config:self.dataArray];
        return header;
    }
    return nil;
}




@end
