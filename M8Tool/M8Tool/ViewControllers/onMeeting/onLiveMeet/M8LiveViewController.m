//
//  M8LiveViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveViewController.h"

#import "M8LiveViewController+UI.h"
#import "M8LiveViewController+Net.h"
#import "M8LiveViewController+AVListener.h"
#import "M8LiveViewController+IMListener.h"

@interface M8LiveViewController ()

@end

@implementation M8LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self initCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 通话相关接口
- (void)initCall
{
    if (self.isHost)
    {
        [self makeLive];
    }
    else
    {
        [self joinLive];
    }
}

- (void)makeLive
{
    TILLiveRoomOption *option = [TILLiveRoomOption defaultHostLiveOption];
    option.controlRole = @"LiveMaster";
    option.avOption.autoHdAudio = YES;//使用高音质模式，可以传背景音乐
//    option.roomDisconnectListener = self;
    option.imOption.imSupport = YES;
    
    LoadView *createRoomWaitView = [LoadView loadViewWith:@"正在创建房间"];
    [self.view addSubview:createRoomWaitView];
    
    //设置本地画面代理
    [[ILiveRoomManager getInstance] setLocalVideoDelegate:self];
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    //设置消息监听
    [manager setIMListener:self];
    //设置音视频事件监听
    [manager setAVListener:self];
    //设置承载渲染的界面
    [manager setAVRootView:self.livePlayView];
    
    WCWeakSelf(self);
    [manager createRoom:(int)self.liveItem.info.roomnum option:option succ:^{
        [createRoomWaitView removeFromSuperview];
        
//        [weakself.livingInfoView addTextToView:@"创建房间成功"];
        
        [[ILiveRoomManager getInstance] setBeauty:2];
        [[ILiveRoomManager getInstance] setWhite:2];
        //        [_bottomView setMicState:YES];//重新设置麦克风的状态
        
        //将房间参数保存到本地，如果异常退出，下次进入app时，可提示返回这次的房间
        //        [ws.liveItem saveToLocal];
        //        [ws setSelfInfo];
        //
        //        [ws initAudio];
    
        [self onNetReportRoomInfo];
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        [createRoomWaitView removeFromSuperview];
        
//        NSString *errinfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
//        [weakself.livingInfoView addTextToView:errinfo];
    }];
    
}

- (void)joinLive
{
    
}


#pragma mark - inits
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(self.view.width * 2, self.view.height);
        scrollView.contentOffset = CGPointMake(self.view.width, 0);
        scrollView.bounces = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [scrollView addSubview:self.liveInfoView];
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (M8LivePlayView *)livePlayView
{
    if (!_livePlayView)
    {
        M8LivePlayView *livePlayView = [[M8LivePlayView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _livePlayView = livePlayView;
    }
    return _livePlayView;
}

- (M8LiveInfoView *)liveInfoView
{
    if (!_liveInfoView)
    {
        M8LiveInfoView *livingInfoView = [[M8LiveInfoView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
        _liveInfoView =livingInfoView;
    }
    return _liveInfoView;
}

- (M8LiveJoinTableView *)tableView {
    if (!_tableView) {
        M8LiveJoinTableView *tableView = [[M8LiveJoinTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - createUI
- (void)createUI
{
    // 实现父类退出按钮的点击事件
    [self.exitButton addTarget:self action:@selector(selfDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.scrollView    belowSubview:self.exitButton];
    [self.view insertSubview:self.livePlayView  belowSubview:self.scrollView];
    [self.view insertSubview:self.tableView     belowSubview:self.livePlayView];
    
    if (!self.isHost)
    {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
    }
}


/**
 需要随着手指移动的视图，只计算竖直方向的位移
 self.scrollView
 self.livePlayView
 self.tableView
 */
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.view];
    
    
    
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            
            [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        }
            break;
        default:
            break;
    }
}




- (void)selfDismiss {
    
    //通知业务服务器，退房
    [self onNetReportExitRoom];
    
    TILLiveManager *manager = [TILLiveManager getInstance];
//    __weak typeof(self) ws = self;
    [manager quitRoom:^{
//        [ws.livingInfoView addTextToView:@"退出房间成功"];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
//        [ws.livingInfoView addTextToView:[NSString stringWithFormat:@"退出房间失败,moldle=%@;errid=%d;errmsg=%@",moudle,errId,errMsg]];
    }];
    
    [super selfDismiss];
}

@end
