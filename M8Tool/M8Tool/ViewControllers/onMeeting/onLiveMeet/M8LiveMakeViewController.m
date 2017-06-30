//
//  M8LiveMakeViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveMakeViewController.h"
#import "M8LiveInfoView.h"

@interface M8LiveMakeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation M8LiveMakeViewController
@synthesize livingInfoView;

- (instancetype)initWithItem:(id)item {
    if (self = [super init]) {
        _liveItem = item;
        _isHost = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.livingInfoView.host = self.host;
    self.livingPlayView.host = self.host;
    
    [self createUI];
    
    [self createLive];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建直播
- (void)createLive{
    TILLiveRoomOption *option = [TILLiveRoomOption defaultHostLiveOption];
    option.controlRole = @"LiveMaster";
    TILLiveManager *manager = [TILLiveManager getInstance];
    
    [manager setIMListener:self.livingInfoView];
    [manager setAVListener:self.livingPlayView];
    [manager setAVRootView:self.livingPlayView];
    
    __weak typeof(self) ws = self;
    [manager createRoom:_roomId option:option succ:^{
        [ws.livingInfoView addTextToView:@"创建房间成功"];
        
        [[ILiveRoomManager getInstance] setBeauty:2];
        [[ILiveRoomManager getInstance] setWhite:2];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws.livingInfoView addTextToView:[NSString stringWithFormat:@"创建房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];
    }];
}
#pragma mark - 创建界面
- (void)createUI {
    [self scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(self.view.width * 2, self.view.height);
        scrollView.contentOffset = CGPointMake(self.view.width, 0);
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        livingInfoView = [[M8LiveInfoView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
        [scrollView addSubview:livingInfoView];
        
        [self.view insertSubview:(_scrollView = scrollView) aboveSubview:self.livingPlayView];
    }
    return _scrollView;
}

- (void)selfDismiss {
    TILLiveManager *manager = [TILLiveManager getInstance];
    __weak typeof(self) ws = self;
    [manager quitRoom:^{
        [ws.livingInfoView addTextToView:@"退出房间成功"];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [ws.livingInfoView addTextToView:[NSString stringWithFormat:@"退出房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];
    }];
    
    [super selfDismiss];
}
@end
