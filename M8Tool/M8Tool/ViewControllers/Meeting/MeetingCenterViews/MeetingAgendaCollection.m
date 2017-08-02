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

@property (nonatomic, strong) NSArray *itemsArray;

@property (nonatomic, assign) NSUInteger currentDay; //如果数组中有，则记录当天，如果没有，则表示离今天最近的后来的某天

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
        
        [self loadCalendarData];
    }
    return self;
}

- (void)loadCalendarData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSArray *calendarData = [CommonUtil getCalendarData];
        
        self.itemsArray = calendarData;
        
        NSDate *todayDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDateComponents *comps = [DAYUtils dateComponentsFromDate:todayDate];
        NSUInteger curDay   = comps.day;
        NSUInteger curMonth = comps.month;
        NSUInteger curWeek  = [DAYUtils curWeekdayComponents:comps] - 1;

        
        for (int i = 0; i < calendarData.count; i++)
        {
            NSDateComponents *compts = calendarData[i];
            
            if (compts.day == curDay &&
                compts.month == curMonth)
            {
                _currentDay = i;
                break ;
            }
        }
        
        if (curWeek == 6 ||
            curWeek == 0)
        {
            _currentDay = 5;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reloadData];
        });
        
    });
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.itemsArray)
    {
        return self.itemsArray.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingAgendaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeetingAgendaCellID" forIndexPath:indexPath];
    
    if (self.itemsArray &&
        indexPath.row < self.itemsArray.count)
    {
        NSDateComponents *compts = self.itemsArray[indexPath.row];
        
        NSString *dayStr = [NSString stringWithFormat:@"%ld", compts.day];
        NSString *monthImg = [NSString stringWithFormat:@"month%ld", compts.month];
        
        if (indexPath.row < _currentDay)
        {
            [cell configWithDay:dayStr monthImg:monthImg dayColor:WCLightGray];
        }
        else if (indexPath.row == _currentDay)
        {
            [cell configWithDay:dayStr monthImg:monthImg dayColor:WCRed];
        }
        else
        {
            [cell configWithDay:dayStr monthImg:monthImg dayColor:WCBlack];
        }
            
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_agendaDelegate respondsToSelector:@selector(AgendaCollectionCurrentPage:)])
    {
        [_agendaDelegate AgendaCollectionCurrentPage:(int)self.contentOffset.x / SCREEN_WIDTH];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([_agendaDelegate respondsToSelector:@selector(AgendaCollectionCurrentPage:)])
    {
        [_agendaDelegate AgendaCollectionCurrentPage:(int)self.contentOffset.x / SCREEN_WIDTH];
    }
}

- (void)reloadData
{
    [super reloadData];
    
    NSInteger showOffsetPage = _currentDay / 5;
    CGPoint lastPoint = self.contentOffset;
    lastPoint.x = self.width * showOffsetPage;
    [self setContentOffset:lastPoint animated:YES];
    
    
    if ([_agendaDelegate respondsToSelector:@selector(AgendaCollectionNumberPage:)])
    {
        if (self.itemsArray)
        {
            [_agendaDelegate AgendaCollectionNumberPage:[self getTotalPage:self.itemsArray.count]];
        }
        else
        {
            [_agendaDelegate AgendaCollectionNumberPage:0];
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self onPushAgendaVC];
}

- (void)onPushAgendaVC
{
    M8MeetAgendaViewController *agendaVC = [[M8MeetAgendaViewController alloc] init];
    agendaVC.isExitLeftItem = YES;
    [[AppDelegate sharedAppDelegate] pushViewControllerWithBottomBarHidden:agendaVC];
}

- (int)getTotalPage:(NSInteger)count
{
    return (int)(count % 5 == 0 ? count / 5 : count / 5 + 1);
}
@end
