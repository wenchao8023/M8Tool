//
//  M8MeetRecordViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRecordViewController.h"
#import "M8MeetRecordTableView.h"

#import "M8GlobalNetTipView.h"

@interface M8MeetRecordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) M8MeetRecordTableView *tableView;
@property (nonatomic, strong) M8GlobalNetTipView *netTipView;

@end

@implementation M8MeetRecordViewController
@synthesize _searchView;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_listViewType == M8MeetListViewTypeNote ||
        _listViewType == M8MeetListViewTypeCollect)
    {
        
        // 添加 搜索视图
        [self addSearchView];
        
        // 重新设置内容视图 >> 添加 tableView
        [self resetContentView];
    }
    
    [self.contentView addSubview:self.tableView];
    
    [WCNotificationCenter addObserver:self selector:@selector(onNetStatusNotifi:) name:kAppNetStatus_Notification object:nil];
}

- (M8MeetRecordTableView *)tableView
{
    if (!_tableView)
    {
        M8MeetRecordTableView *tableView = [[M8MeetRecordTableView alloc] initWithFrame:self.contentView.bounds
                                                                              style:UITableViewStylePlain
                                                                       listViewType:_listViewType];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)addSearchView
{
    CGRect frame = self.contentView.frame;
    frame.size.height = kSearchView_height;
    BaseSearchView *searchView = [[BaseSearchView alloc] initWithFrame:frame target:self];
    WCViewBorder_Radius(searchView, kSearchView_height / 2);
    searchView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:(_searchView = searchView)];
}

- (void)resetContentView
{
    CGFloat originY = CGRectGetMaxY(_searchView.frame) + kMarginView_top;
    self.contentView.y = originY;
    self.contentView.height = self.contentView.height - originY + kDefaultNaviHeight;
}

- (M8GlobalNetTipView *)netTipView
{
    if (!_netTipView)
    {
        M8GlobalNetTipView *netTipView = [[M8GlobalNetTipView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, kDefaultCellHeight)];
        _netTipView = netTipView;
    }
    return _netTipView;
}

#pragma mark - 判断视图类型
- (NSString *)getTitle {
    switch (self.listViewType) {
        case M8MeetListViewTypeRecord:
            return @"会议记录";
            break;
        case M8MeetListViewTypeNote:
            return @"会议笔记";
            break;
        case M8MeetListViewTypeCollect:
            return @"会议收藏";
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        self.tableView.y = kDefaultCellHeight;
        [self.contentView addSubview:self.netTipView];
        [self.contentView bringSubviewToFront:self.netTipView];
    }
    else
    {
        if (_netTipView)
        {
            self.tableView.y = 0;
            [self.netTipView removeFromSuperview];
            self.netTipView = nil;
        }
    }
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kAppNetStatus_Notification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
