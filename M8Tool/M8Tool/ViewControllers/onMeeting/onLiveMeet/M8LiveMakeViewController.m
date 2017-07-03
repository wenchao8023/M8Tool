//
//  M8LiveMakeViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveMakeViewController.h"
#import "M8LiveInfoView.h"

@interface M8LiveMakeViewController ()<ILiveRoomDisconnectListener, QAVLocalVideoDelegate>

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
    self.livingInfoView.host = _liveItem.info.host;
    self.livingPlayView.host = _liveItem.info.host;
    
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
    option.avOption.autoHdAudio = YES;//使用高音质模式，可以传背景音乐
    option.roomDisconnectListener = self;
    option.imOption.imSupport = YES;
    
    LoadView *createRoomWaitView = [LoadView loadViewWith:@"正在创建房间"];
    [self.view addSubview:createRoomWaitView];
    
    //设置本地画面代理
    [[ILiveRoomManager getInstance] setLocalVideoDelegate:self];
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    //设置消息监听
    [manager setIMListener:self.livingInfoView];
    //设置音视频事件监听
    [manager setAVListener:self.livingPlayView];
    //设置承载渲染的界面
    [manager setAVRootView:self.livingPlayView];
    
    WCWeakSelf(self);
    [manager createRoom:(int)_liveItem.info.roomnum option:option succ:^{
        [createRoomWaitView removeFromSuperview];
        
        [weakself.livingInfoView addTextToView:@"创建房间成功"];
        
        [[ILiveRoomManager getInstance] setBeauty:2];
        [[ILiveRoomManager getInstance] setWhite:2];
//        [_bottomView setMicState:YES];//重新设置麦克风的状态
        
        //将房间参数保存到本地，如果异常退出，下次进入app时，可提示返回这次的房间
//        [ws.liveItem saveToLocal];
//        [ws setSelfInfo];
//        
//        [ws initAudio];
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        [createRoomWaitView removeFromSuperview];
        
        NSString *errinfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
        [weakself.livingInfoView addTextToView:errinfo];
    }];
    
    [self reportRoomInfo:(int)_liveItem.info.roomnum groupId:_liveItem.info.groupid];
}

- (void)reportRoomInfo:(int)roomId groupId:(NSString *)groupid
{
    WCWeakSelf(self);
    ReportRoomRequest *reportReq = [[ReportRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        [weakself.livingInfoView addTextToView:@"上报房间信息成功"];
    } failHandler:^(BaseRequest *request) {
        // 上传失败
        [weakself.livingInfoView addTextToView:@"上报房间信息失败"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errinfo = [NSString stringWithFormat:@"code=%ld,msg=%@",(long)request.response.errorCode,request.response.errorInfo];
            [AlertHelp alertWith:@"上传RoomInfo失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        });
    }];
    
    reportReq.token = [AppDelegate sharedAppDelegate].token;
    
    reportReq.room = [[ShowRoomInfo alloc] init];
    reportReq.room.title = _liveItem.info.title;
    reportReq.room.type = @"live";
    reportReq.room.roomnum = roomId;
    reportReq.room.groupid = [NSString stringWithFormat:@"%d",roomId];
    reportReq.room.cover = _liveItem.info.cover.length > 0 ? _liveItem.info.cover : @"";
    reportReq.room.appid = [ShowAppId intValue];
    
    [[WebServiceEngine sharedEngine] asyncRequest:reportReq];
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
