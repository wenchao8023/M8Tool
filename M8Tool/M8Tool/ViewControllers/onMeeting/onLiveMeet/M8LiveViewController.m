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
    
    [WCNotificationCenter addObserver:self selector:@selector(onHiddeMenuView) name:kHiddenMenuView_Notifycation object:nil];
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
    option.controlRole = kSxbRole_Host;
    option.avOption.autoHdAudio = YES;//使用高音质模式，可以传背景音乐
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
    
//    WCWeakSelf(self);
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
        
        
        ILivePushOption *option = [[ILivePushOption alloc] init];
        ILiveChannelInfo *info = [[ILiveChannelInfo alloc] init];
        info.channelName = @"测试频道";     //直播码模式下无意义
        info.channelDesc = @"测试频道描述";  //直播码模式下无意义
        option.channelInfo = info;
        option.encodeType = AV_ENCODE_HLS;
        option.recrodFileType = AV_RECORD_FILE_TYPE_HLS;
        
        [[ILiveRoomManager getInstance] startPushStream:option succ:^(id selfPtr) {
            AVStreamerResp *resp = (AVStreamerResp *)selfPtr;
            NSLog(@"推流成功 %@", [resp urls]);
            WCLog(@"=================================");
            for (AVLiveUrl *url in [resp urls])
            {
                WCLog(@"%@", [NSString stringWithFormat:@"推流地址是:\t%@", url.playUrl]);
            }
            WCLog(@"=================================");
            NSLog(@"推流获取到的频道ID：%llu", resp.channelID);
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            NSLog(@"推流失败");
        }];
        
        
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        [createRoomWaitView removeFromSuperview];
        
//        NSString *errinfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
//        [weakself.livingInfoView addTextToView:errinfo];
    }];
    
}

- (void)joinLive
{
    TILLiveRoomOption *option = [TILLiveRoomOption defaultGuestLiveOption];
    option.controlRole = kSxbRole_Guest;
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    //设置消息监听
    [manager setIMListener:self];
    //设置音视频事件监听
    [manager setAVListener:self];
    //设置承载渲染的界面
    [manager setAVRootView:self.livePlayView];
    
    __weak typeof(self) ws = self;
    [manager joinRoom:(int)self.liveItem.info.roomnum option:option succ:^{
        NSLog(@"join room succ");
//        [ws sendJoinRoomMsg];
//        [ws setSelfInfo];
        
    } failed:^(NSString *module, int errId, NSString *errMsg)
     {
        NSString *errLog = [NSString stringWithFormat:@"join room fail. module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
        [AlertHelp alertWith:@"加入房间失败" message:errLog cancelBtn:@"退出" alertStyle:UIAlertControllerStyleAlert cancelAction:^(UIAlertAction * _Nonnull action) {
            [ws selfDismiss];
        }];
    }];
}


#pragma mark - inits
#pragma mark -- views container
- (M8LiveJoinTableView *)tableView {
    if (!_tableView) {
        M8LiveJoinTableView *tableView = [[M8LiveJoinTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView = tableView;
    }
    return _tableView;
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

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
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

- (M8LiveInfoView *)liveInfoView
{
    if (!_liveInfoView)
    {
        M8LiveInfoView *livingInfoView = [[M8LiveInfoView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
        
        [livingInfoView addSubview:self.headerView];
        [livingInfoView addSubview:self.noteView];
        [livingInfoView addSubview:self.deviceView];
        
        _liveInfoView = livingInfoView;
    }
    return _liveInfoView;
}

- (M8LiveHeaderView *)headerView
{
    if (!_headerView)
    {
        M8LiveHeaderView *headerView = [[M8LiveHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kDefaultNaviHeight)];
        _headerView = headerView;
    }
    return _headerView;
}

- (M8LiveNoteView *)noteView
{
    if (!_noteView)
    {
        M8LiveNoteView *noteView = [[M8LiveNoteView alloc] initWithFrame:CGRectMake(0, self.view.height - kBottomHeight - 200, self.view.width, 200)];
        _noteView = noteView;
    }
    return _noteView;
}

- (M8MeetDeviceView *)deviceView
{
    if (!_deviceView)
    {
        M8MeetDeviceView *deviceView = [[M8MeetDeviceView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        _deviceView = deviceView;
    }
    return _deviceView;
}

- (M8MenuPushView *)menuView
{
    if (!_menuView)
    {
        M8MenuPushView *menuView = [[M8MenuPushView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomHeight)
                                                               itemCount:self.liveItem.callType == TILCALL_TYPE_VIDEO ? 4 : 2
                                                                meetType:M8MeetTypeLive
                                    ];
        [self.view addSubview:menuView];
        [self.view bringSubviewToFront:menuView];
        _menuView = menuView;
    }
    return _menuView;
}



#pragma mark -- datas container
- (NSMutableArray *)identifierArray
{
    if (!_identifierArray)
    {
        _identifierArray = [[NSMutableArray alloc] init];
    }
    return _identifierArray;
}

- (NSMutableArray *)srcTypeArray
{
    if (!_srcTypeArray)
    {
        _srcTypeArray = [[NSMutableArray alloc] init];
    }
    return _srcTypeArray;
}




#pragma mark - createUI
- (void)createUI
{
    // 实现父类退出按钮的点击事件
    [self.exitButton addTarget:self action:@selector(selfDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.scrollView    belowSubview:self.exitButton];
    [self.view insertSubview:self.livePlayView  belowSubview:self.scrollView];
    
    
    if (!self.isHost)
    {
        [self.view insertSubview:self.tableView     belowSubview:self.livePlayView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
    }
}

- (void)addTextToView:(id)newText
{
    NSString *text = self.noteView.textView.text;
    
    NSString *dicStr = [NSString stringWithFormat:@"%@", newText];
    dicStr = [dicStr stringByAppendingString:@"\n"];
    dicStr = [dicStr stringByAppendingString:text];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.noteView.textView.text = dicStr;
    });
}


- (void)selfDismiss {
    
    BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:kPushMenuStatus];
    if (ret)
    {
        [self onHiddeMenuView];
        return ;
    }
    
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


#pragma mark - 观众端添加移动手势
/**
 需要随着手指移动的视图，只计算竖直方向的位移
 self.scrollView
 self.livePlayView
 self.tableView     要做成轮播图样式
 */
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.view];

    [self panChanged:translation.y];
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        [self panEnded];
    }
    
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)panChanged:(CGFloat)transY
{
    self.scrollView.y       += transY;
    self.livePlayView.y     += transY;
    
    CGPoint tableViewY      = self.tableView.contentOffset;
    tableViewY.y            -= transY;
    [self.tableView setContentOffset:tableViewY];
}

- (void)panEnded
{
    CGFloat offsetY = self.livePlayView.y;
    
    if (offsetY > SCREEN_WIDTH * 0.2)            //下滑
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGPoint tableViewY      = self.tableView.contentOffset;
            tableViewY.y            -= (SCREEN_HEIGHT - offsetY);
            [self.tableView setContentOffset:tableViewY];
            
            self.scrollView.y = SCREEN_HEIGHT;
            self.livePlayView.y = SCREEN_HEIGHT;
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                self.scrollView.y = 0;
                self.livePlayView.y = 0;
            }
        }];
    }
    else if (offsetY <= -(SCREEN_WIDTH * 0.2))   //上滑
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGPoint tableViewY      = self.tableView.contentOffset;
            tableViewY.y            += (SCREEN_HEIGHT + offsetY);
            [self.tableView setContentOffset:tableViewY];
            
            self.scrollView.y = -SCREEN_HEIGHT;
            self.livePlayView.y = -SCREEN_HEIGHT;
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                self.scrollView.y = 0;
                self.livePlayView.y = 0;
            }
        }];
    }
    else    //还原
    {
        [UIView animateWithDuration:0.06 animations:^{
            
            CGPoint tableViewY      = self.tableView.contentOffset;
            tableViewY.y            += offsetY;
            [self.tableView setContentOffset:tableViewY];
            
            self.scrollView.y   -= offsetY;
            self.livePlayView.y -= offsetY;
            
        }];
    }
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
}

@end
