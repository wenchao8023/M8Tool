//
//  MeetingAgendaCollection.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingAgendaCollection.h"
#import "MeetingAgendaCell.h"
#import "M8MeetAgendaViewController.h"



@interface MeetingAgendaCollection ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGRect _myFrame;
}
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MeetingAgendaCollection


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = WCClear;
        self.delegate        = self;
        self.dataSource      = self;
        self.pagingEnabled   = YES;
        self.showsHorizontalScrollIndicator = NO;
        
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MeetingAgendaCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingAgendaCellID"];
    }
    return self;
}


- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        NSArray *titleArray = @[@"17", @"16", @"15", @"14", @"13",
                                @"11", @"10", @"9", @"8", @"7",
                                @"6", @"5", @"4", @"3", @"2"];
        _titleArray = titleArray;
    }
    return _titleArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:1 itemCountPerRow:5];
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH / 5);
//    layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing       = 0;
//    layout.minimumInteritemSpacing  = 0;
//
//    
//    
//    self.collectionViewLayout   = layout;
//    self.delegate               = self;
//    self.dataSource             = self;
//    self.pagingEnabled          = YES;
//    self.showsHorizontalScrollIndicator = NO;
//
//    [self registerNib:[UINib nibWithNibName:NSStringFromClass([MeetingAgendaCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MeetingAgendaCellID"];
    
//#warning 需要将数据处理部分放到 viewModel 里面处理
//    if ([_agendaDelegate respondsToSelector:@selector(AgendaCollectionNumberPage:)]) {
//        [_agendaDelegate AgendaCollectionNumberPage:[self getTotalPage:self.titleArray.count]];
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeetingAgendaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingAgendaCellID" forIndexPath:indexPath];
    
    [cell configWithTitle:self.titleArray[indexPath.row] imageStr:@""];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_agendaDelegate respondsToSelector:@selector(AgendaCollectionCurrentPage:)])
    {
        [_agendaDelegate AgendaCollectionCurrentPage:(int)self.contentOffset.x / SCREEN_WIDTH];
    }
}

- (void)reloadData
{
    [super reloadData];
    
    if ([_agendaDelegate respondsToSelector:@selector(AgendaCollectionNumberPage:)])
    {
        [_agendaDelegate AgendaCollectionNumberPage:[self getTotalPage:self.titleArray.count]];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    M8MeetAgendaViewController *agendaVC = [[M8MeetAgendaViewController alloc] init];
    agendaVC.isExitLeftItem = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:agendaVC];
    WCLog(@"点击第 %ld 个按钮", (long)indexPath.row);
}

- (int)getTotalPage:(NSInteger)count
{
    return (int)(count % 5 == 0 ? count / 5 : count / 5 + 1);
}
@end
