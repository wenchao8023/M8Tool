//
//  MeetingViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingViewController.h"
#import "MeetingViewController+IFlyMSC.h"
#import "MeetingAgendaCollection.h"
#import "MeetingAgendaHeader.h"

#import "M8MeetWindow.h"
#import "M8LiveViewController.h"
#import "M8MeetListViewController.h"
#import "M8GlobalNetTipView.h"

@interface MeetingViewController ()<AgendaCollectionDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *headerScroll;
@property (nonatomic, strong) UIImageView  *bannerImage;

@property (nonatomic, strong) MeetingAgendaHeader     *agendaHeader;
@property (nonatomic, strong) MeetingAgendaCollection *agendaCollection;
@property (nonatomic, strong) UIPageControl           *pageControl;


@property (nonatomic, strong) UILabel  *agendaCollectionHeadLabel;
@property (nonatomic, strong) UIButton *agendaCollectionMoreButton;

//加载scrollView轮播图图片
@property (nonatomic, strong) NSArray *scrollImgArray;
@property (nonatomic, strong) NSTimer *scrollTimer;

@property (nonatomic, strong) M8GlobalNetTipView *netTipView;

@end

@implementation MeetingViewController

#pragma mark - -- views life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议中心"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 重新设置导航视图 >> 添加右侧按钮
    [self resetNavi];
    
    [self reloadSuperViews];
    
    [WCNotificationCenter addObserver:self selector:@selector(onNetStatusNotifi:) name:kAppNetStatus_Notification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - -- UI
- (void)resetNavi
{
    CGFloat btnWidth                           = 40;
    UIImageView *speechIV                      = [WCUIKitControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH - 10 - btnWidth, kDefaultStatuHeight + 2, btnWidth, btnWidth) ImageName:@"speechOff" Target:self Action:@selector(onSpeechAction)];
    [self.headerView addSubview:(self.speechIV = speechIV)];
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

- (void)reloadScrollView
{
    self.headerScroll.contentSize   = CGSizeMake(self.view.width * self.scrollImgArray.count, self.headerScroll.height);
    self.headerScroll.contentOffset = CGPointMake(self.view.width, 0);
    
    for (int i = 0; i < self.scrollImgArray.count; i++)
    {
        UIImageView *headerImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(self.headerScroll.width * i, 0, self.headerScroll.width, self.headerScroll.height) ImageName:self.scrollImgArray[i]];
        headerImg.tag          = 120 + i;
        [self.headerScroll addSubview:headerImg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderImgAction:)];
        [headerImg addGestureRecognizer:tap];
    }
    
    [self.scrollTimer fire];
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
    
    WCWeakSelf(self);
    self.agendaHeader.onMoreAgendaActionBlock = ^{
        
        [weakself.agendaCollection onPushAgendaVC];
    };
}


#pragma mark - -- inits
- (MeetingButtonsCollection *)buttonsCollection
{
    if (!_buttonsCollection)
    {
        WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:2 itemCountPerRow:4];
        layout.itemSize                          = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        layout.scrollDirection                   = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing                = 0;
        layout.headerReferenceSize               = CGSizeMake(0, 0);
        layout.minimumInteritemSpacing           = 0;
        
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
        UIPageControl *pageControl                = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) / 2, self.buttonsCollection.y - 20, 60, 20)];
        pageControl.pageIndicatorTintColor        = WCLightGray;
        pageControl.currentPageIndicatorTintColor = WCWhite;
        [self.view addSubview:(_pageControl       = pageControl)];
    }
    return _pageControl;
}

- (MeetingAgendaCollection *)agendaCollection
{
    if (!_agendaCollection)
    {
        WCCollectionViewHorizontalLayout *layout = [[WCCollectionViewHorizontalLayout alloc] initWithRowCount:1 itemCountPerRow:5];
        layout.itemSize                          = CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH / 5);
        layout.scrollDirection                   = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing                = 0;
        layout.minimumInteritemSpacing           = 0;
        
        MeetingAgendaCollection *agendaCollection = [[MeetingAgendaCollection alloc] initWithFrame:CGRectMake(0, self.pageControl.y - SCREEN_WIDTH / 5, SCREEN_WIDTH, SCREEN_WIDTH / 5)
                                                                              collectionViewLayout:layout];
        agendaCollection.agendaDelegate          = self;
        [self.view addSubview:(_agendaCollection = agendaCollection)];
    }
    
    return _agendaCollection;
}

- (MeetingAgendaHeader *)agendaHeader
{
    if (!_agendaHeader)
    {
        MeetingAgendaHeader *agendaHeader    = [[MeetingAgendaHeader alloc] initWithFrame:CGRectMake(0, self.agendaCollection.y - 30, self.view.width, 30)];
        [self.view addSubview:(_agendaHeader = agendaHeader)];
    }
    
    return _agendaHeader;
}


- (UIScrollView *)headerScroll
{
    //不要用agendaHeader判断
    if (!_headerScroll)
    {
        UIScrollView *headerScroll                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.agendaCollection.y - 64 - 30)];
        headerScroll.backgroundColor                = WCClear;
        headerScroll.delegate                       = self;
        headerScroll.pagingEnabled                  = YES;
        headerScroll.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:(_headerScroll        = headerScroll)];
    }
    
    return _headerScroll;
}

- (NSArray *)scrollImgArray
{
    if (!_scrollImgArray)
    {
        if (iPhone4)
        {
            _scrollImgArray = @[@"M8_4", @"MeetingViewHeader4", @"M8_4", @"MeetingViewHeader4"];
        }
        else if (iPhone5)
        {
            _scrollImgArray = @[@"M8_5", @"MeetingViewHeader5", @"M8_5", @"MeetingViewHeader5"];
        }
        else if (iPhone6P)
        {
            _scrollImgArray = @[@"M8_6p", @"MeetingViewHeader6p", @"M8_6p", @"MeetingViewHeader6p"];
        }
        else    //默认是 iPhone6 的标准尺寸
        {
            _scrollImgArray = @[@"M8_6", @"MeetingViewHeader6", @"M8_6", @"MeetingViewHeader6"];
        }
    }
    return _scrollImgArray;
}

- (IFlySpeechRecognizer *)iFlySpeechRecognizer
{
    if (!_iFlySpeechRecognizer)
    {
        //创建语音识别对象
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];//设置识别参数
        
        //设置为听写模式
        [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        
        //asr_audio_path 是录音文件名，设置 value 为 nil 或者为空取消保存，默认保存目录在 Library/cache 下。
        [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        //设置代理
        [_iFlySpeechRecognizer setDelegate:self];
    }
    return _iFlySpeechRecognizer;
}



- (NSTimer *)scrollTimer
{
    if (!_scrollTimer)
    {
        //鱼只有 7s 的记忆，7s 之后就不记得上一个图片了
        NSTimer *scrollTimer = [NSTimer timerWithTimeInterval:7.0 target:self selector:@selector(onScrollImageTimer) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:scrollTimer forMode:NSRunLoopCommonModes];
        
        _scrollTimer = scrollTimer;
    }
    return _scrollTimer;
}

- (M8GlobalNetTipView *)netTipView
{
    if (!_netTipView)
    {
        M8GlobalNetTipView *netTipView = [[M8GlobalNetTipView alloc] initWithFrame:CGRectMake(0, kDefaultNaviHeight, self.view.width, kDefaultCellHeight)];
        _netTipView                    = netTipView;
    }
    return _netTipView;
}

#pragma mark - -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self scrollTimer];
}

//手动滑动之后调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setHeaderScrollOffsetInBackground];
}
//调用 setContentOffset/scrollRectVisible:animated: 之后触发的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setHeaderScrollOffsetInBackground];
}

#pragma mark - -- 轮播图
- (void)onScrollImageTimer
{
    CGPoint lastOffset = self.headerScroll.contentOffset;
    lastOffset.x       += self.headerScroll.width;
    
    [self.headerScroll setContentOffset:lastOffset animated:YES];
}

- (void)setHeaderScrollOffsetInBackground
{
    if (self.headerScroll.contentOffset.x >= self.headerScroll.width * 3)
    {
        [self.headerScroll setContentOffset:CGPointMake(self.headerScroll.width, 0) animated:NO];
    }
    else if (self.headerScroll.contentOffset.x <= 0)
    {
        [self.headerScroll setContentOffset:CGPointMake(self.headerScroll.width * 2, 0) animated:NO];
    }
}


#pragma mark - -- actions
- (void)onHeaderImgAction:(UITapGestureRecognizer *)tap
{
    UIView *headImg = tap.view;
    NSInteger tag   = headImg.tag - 120;
    if (tag == 1)
    {
        M8MeetListViewController *listVC = [[M8MeetListViewController alloc] init];
        listVC.isExitLeftItem            = YES;
        [[AppDelegate sharedAppDelegate] pushViewControllerWithBottomBarHidden:listVC];
    }
    else if (tag == 2)
    {
        //        [AlertHelp tipWith:@"去购买会议系统吧，木木!!!" wait:2];
    }
}


#pragma mark - AgendaCollectionDelegate
- (void)AgendaCollectionNumberPage:(int)pageNumber
{
    //    WCLog(@"numberOfPages is : %d", pageNumber);
    self.pageControl.numberOfPages = pageNumber;
    [self.pageControl setWidth:20 * pageNumber];
}

- (void)AgendaCollectionCurrentPage:(int)pageIndex
{
    //    WCLog(@"pageIndex is : %d", pageIndex);
    self.pageControl.currentPage = pageIndex;
}

#pragma mark - -- notifications
- (void)onNetStatusNotifi:(NSNotification *)notification
{
    id obj = notification.object;
    
    AFNetworkReachabilityStatus netStatu;
    [obj getValue:&netStatu];
    
    if (netStatu == AFNetworkReachabilityStatusUnknown ||
        netStatu == AFNetworkReachabilityStatusNotReachable)
    {
        [self.view addSubview:self.netTipView];
        [self.view bringSubviewToFront:self.netTipView];
    }
    else
    {
        if (_netTipView)
        {
            [self.netTipView removeFromSuperview];
            self.netTipView = nil;
        }
    }
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kAppNetStatus_Notification object:nil];
}



@end
