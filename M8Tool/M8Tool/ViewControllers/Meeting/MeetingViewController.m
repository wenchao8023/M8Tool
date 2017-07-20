//
//  MeetingViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingViewController.h"
#import "MeetingAgendaCollection.h"
#import "MeetingButtonsCollection.h"
#import "MeetingAgendaHeader.h"

#import "M8MeetWindow.h"
#import "M8LiveViewController.h"

#import "M8MeetListViewController.h"

@interface MeetingViewController ()<AgendaCollectionDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView              *headerScroll;
@property (nonatomic, strong) UIImageView                *bannerImage;

@property (nonatomic, strong) MeetingAgendaHeader        *agendaHeader;
@property (nonatomic, strong) MeetingAgendaCollection    *agendaCollection;
@property (nonatomic, strong) MeetingButtonsCollection   *buttonsCollection;
@property (nonatomic, strong) UIPageControl              *pageControl;


@property (nonatomic, strong) UILabel *agendaCollectionHeadLabel;
@property (nonatomic, strong) UIButton *agendaCollectionMoreButton;

//加载scrollView轮播图图片
@property (nonatomic, strong) NSArray *scrollImgArray;
@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation MeetingViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议中心"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reloadSuperViews];
}



- (void)reloadSuperViews
{
    
    self.contentView.hidden = YES;
    
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.view setHeight:SCREEN_HEIGHT - kDefaultTabbarHeight];
   
    self.bgImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:self.bgImageView];
    
    [self addSubviews];
}

//添加视图的顺序应挨个是从下往上的
- (void)addSubviews
{
    [self buttonsCollection];
    [self pageControl];
    [self agendaCollection];
    [self agendaHeader];
    [self headerScroll];
    [self reloadScrollView];
}

- (MeetingButtonsCollection *)buttonsCollection
{
    if (!_buttonsCollection)
    {
        WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:2 itemCountPerRow:4];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing       = 0;
        layout.headerReferenceSize      = CGSizeMake(0, 0);
        layout.minimumInteritemSpacing  = 0;
        
        MeetingButtonsCollection *buttonsCollection = [[MeetingButtonsCollection alloc] initWithFrame:CGRectMake(0, self.view.height - SCREEN_WIDTH / 2 - 20, SCREEN_WIDTH, SCREEN_WIDTH / 2)
                                                                                 collectionViewLayout:layout];
        [self.view addSubview:(_buttonsCollection = buttonsCollection)];
    }
    
    return _buttonsCollection;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) / 2, self.buttonsCollection.y - 20, 60, 20)];
        pageControl.pageIndicatorTintColor = WCLightGray;
        pageControl.currentPageIndicatorTintColor = WCWhite;
        [self.view addSubview:(_pageControl = pageControl)];
    }
    return _pageControl;
}

- (MeetingAgendaCollection *)agendaCollection
{
    if (!_agendaCollection)
    {
        WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:1 itemCountPerRow:5];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH / 5);
        layout.scrollDirection          = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing       = 0;
        layout.minimumInteritemSpacing  = 0;
        
        MeetingAgendaCollection *agendaCollection = [[MeetingAgendaCollection alloc] initWithFrame:CGRectMake(0, self.pageControl.y - SCREEN_WIDTH / 5, SCREEN_WIDTH, SCREEN_WIDTH / 5)
                                                                              collectionViewLayout:layout];
        agendaCollection.agendaDelegate = self;
        [self.view addSubview:(_agendaCollection = agendaCollection)];
    }
    
    return _agendaCollection;
}

- (MeetingAgendaHeader *)agendaHeader
{
    if (!_agendaHeader)
    {
        MeetingAgendaHeader *agendaHeader = [[MeetingAgendaHeader alloc] initWithFrame:CGRectMake(0, self.agendaCollection.y - 30, self.view.width, 30)];
        [self.view addSubview:(_agendaHeader = agendaHeader)];
    }
    
    return _agendaHeader;
}


- (UIScrollView *)headerScroll
{
    //不要用agendaHeader判断
    if (!_headerScroll)
    {
        UIScrollView *headerScroll      = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.agendaCollection.y - 64 - 30)];
        headerScroll.backgroundColor    = WCClear;
        headerScroll.delegate           = self;
        headerScroll.pagingEnabled      = YES;
        headerScroll.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:(_headerScroll = headerScroll)];
    }
    
    return _headerScroll;
}

- (NSArray *)scrollImgArray
{
    if (!_scrollImgArray)
    {
        _scrollImgArray = @[@"M8", @"defaul_publishcover", @"M8", @"defaul_publishcover"];
    }
    return _scrollImgArray;
}

- (void)reloadScrollView
{
    self.headerScroll.contentSize   = CGSizeMake(self.view.width * 4, self.headerScroll.height);
    self.headerScroll.contentOffset = CGPointMake(self.view.width, 0);
    
    for (int i = 0; i < self.scrollImgArray.count; i++)
    {
        UIImageView *headerImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(self.headerScroll.width * i, 0, self.headerScroll.width, self.headerScroll.height) ImageName:self.scrollImgArray[i]];
        headerImg.tag = 120 + i;
        [self.headerScroll addSubview:headerImg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderImgAction:)];
        [headerImg addGestureRecognizer:tap];
    }
    
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(onScrollImageTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSDefaultRunLoopMode];
    [_scrollTimer fire];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setHeaderScrollOffsetInBackground];
}

- (void)onScrollImageTimer
{
    [UIView animateWithDuration:1.0 animations:^{
       
        CGPoint lastOffset = self.headerScroll.contentOffset;
        lastOffset.x += self.headerScroll.width;
        [self.headerScroll setContentOffset:lastOffset animated:YES];
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [self setHeaderScrollOffsetInBackground];
        }
    }];
}

- (void)setHeaderScrollOffsetInBackground
{
    if (self.headerScroll.contentOffset.x == self.headerScroll.width * 3)
    {
        [self.headerScroll setContentOffset:CGPointMake(self.headerScroll.width, 0) animated:NO];
    }
    else if (self.headerScroll.contentOffset.x == 0)
    {
        [self.headerScroll setContentOffset:CGPointMake(self.headerScroll.width * 2, 0) animated:NO];
    }
}



- (void)onHeaderImgAction:(UITapGestureRecognizer *)tap
{
    UIView *headImg = tap.view;
    NSInteger tag = headImg.tag - 120;
    if (tag == 1)
    {
        M8MeetListViewController *listVC = [[M8MeetListViewController alloc] init];
        listVC.isExitLeftItem = YES;
        [[AppDelegate sharedAppDelegate] pushViewControllerWithBottomBarHidden:listVC];
    }
    else if (tag == 2)
    {
        [AlertHelp tipWith:@"去购买会议系统吧，木木!!!" wait:2];
    }
}





#pragma mark - AgendaCollectionDelegate
- (void)AgendaCollectionNumberPage:(int)pageNumber
{
    WCLog(@"numberOfPages is : %d", pageNumber);
    self.pageControl.numberOfPages = pageNumber;
    [self.pageControl setWidth:20 * pageNumber];
}

- (void)AgendaCollectionCurrentPage:(int)pageIndex
{
    WCLog(@"pageIndex is : %d", pageIndex);
    self.pageControl.currentPage = pageIndex;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
