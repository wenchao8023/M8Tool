//
//  M8CollectDetailCollection.m
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CollectDetailCollection.h"

#import "MeetingMembersCell.h"


static NSString *CollectionHeaderID = @"M8CollectDetailCollectionID";
static CGFloat kSectionHeight = 40.f;
#define kItemWidth (self.width - 60) / 5

@interface M8CollectDetailCollection ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end



@implementation M8CollectDetailCollection

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

    [cell configRecordDetailWithNameStr:self.dataArray[indexPath.row] radiusBorder:kItemWidth / 2];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionHeaderID forIndexPath:indexPath];
        
        UILabel *titleLable = [WCUIKitControl createLabelWithFrame:CGRectMake(10, 0, self.width - 20, kSectionHeight) Text:[NSString stringWithFormat:@"互动直播人员: %ld人", self.dataArray.count]];
        [header addSubview:titleLable];
        
        return header;
    }
    return nil;
}



@end
