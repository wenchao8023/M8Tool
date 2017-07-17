//
//  M8CallViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController.h"
#import "M8CallViewController+UI.h"
#import "M8CallViewController+Net.h"
#import "M8CallViewController+CallListener.h"
#import "M8CallViewController+IMListener.h"

@interface M8CallViewController ()

@end

@implementation M8CallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self initCall];
    
    [WCNotificationCenter addObserver:self selector:@selector(onHiddeMenuView) name:kHiddenMenuView_Notifycation object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通话相关接口
- (void)initCall
{
    TILCallConfig * config = [[TILCallConfig alloc] init];
    
    TILCallBaseConfig * baseConfig  = [[TILCallBaseConfig alloc] init];
    baseConfig.heartBeatInterval    = 15;
    baseConfig.isSponsor            = self.isHost;
    baseConfig.callType             = self.liveItem.callType;
    baseConfig.memberArray          = self.liveItem.members;
    config.baseConfig = baseConfig;
    
    TILCallListener * listener      = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self];
    [listener setNotifListener:self];
    [listener setMsgListener:self];
    config.callListener = listener;
    
    if (self.isHost)
    {
        [self makeCall:config]; //创建会议需要在获取到会议ID之后创建，获取到会议ID只需要将成员信息上报给服务器之后才能返回，然后在tip中将会议ID传给接收端
    }
    else
    {
        [self recvCall:config];
    }
}

#pragma mark -- 发起方
- (void)makeCall:(TILCallConfig *)config
{
    __block ReportRoomResponseData *reportRoomData = nil;
    [self onNetReportRoomInfo:^(BaseRequest *request) {
    
        reportRoomData = (ReportRoomResponseData *)request.response.data;
        self.curMid = reportRoomData.mid;
        
        TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
        sponsorConfig.waitLimit             = 30;
        sponsorConfig.callId                = (int)self.liveItem.info.roomnum;
        sponsorConfig.onlineInvite          = NO;
        config.sponsorConfig                = sponsorConfig;
        
        self.call = [[TILMultiCall alloc] initWithConfig:config];
        [self.call createRenderViewIn:self.renderView];
        self.renderView.call = self.call;
        
        
        WCWeakSelf(self);
        [_call makeCall:kGetStringFMInt(self.curMid) custom:self.liveItem.info.title result:^(TILCallError *err) {
            
            if(err){
                [weakself addTextToView:[NSString stringWithFormat:@"呼叫失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
                [weakself selfDismiss];
            }
            else{
                [weakself addTextToView:@"呼叫成功"];
                
                [[ILiveRoomManager getInstance] setBeauty:2];
                [[ILiveRoomManager getInstance] setWhite:2];

                [weakself.headerView configHeaderView:self.liveItem];
                
                //开始推流
                [self onLivePushStart];
            }
        }];
        
    }];
}

/**
 取消
 */
- (void)cancelAllCall
{
    WCWeakSelf(self);
    [_call cancelAllCall:^(TILCallError *err) {
        if(err)
        {
            [weakself addTextToView:[NSString stringWithFormat:@"取消失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [super selfDismiss];
        }
        else
        {
            [weakself addTextToView:@"取消成功"];
            [super selfDismiss];
        }
    }];
}

/**
 挂断
 */
- (void)hangup
{
    WCWeakSelf(self);
    [_call hangup:^(TILCallError *err)
     {
        if(err)
        {
            [weakself addTextToView:[NSString stringWithFormat:@"挂断失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [super selfDismiss];
        }
        else
        {
            [weakself addTextToView:@"挂断成功"];
            [super selfDismiss];
        }
    }];
}


#pragma mark -- 接收方
- (void)recvCall:(TILCallConfig *)config
{
    TILCallResponderConfig *responderConfig = [[TILCallResponderConfig alloc] init];
    responderConfig.callInvitation          = _invitation;
    config.responderConfig                  = responderConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    [_call createRenderViewIn:self.renderView];
    self.renderView.call = _call;
    
    [self addRecvChildVC];
}
//添加接受子视图
- (void)addRecvChildVC
{
    _childVC = [[M8RecvChildViewController alloc] init];
    _childVC.invitation = self.invitation;
    _childVC.WCDelegate = self;
    [self addChildViewController:_childVC];
    [self.view addSubview:_childVC.view];
}
//移除接受子视图
- (void)removeRecvChildVC
{
    [_childVC.view removeFromSuperview];
    [_childVC removeFromParentViewController];
    _childVC = nil;
}
// 接受邀请
- (void)onReceiveCall
{
    WCWeakSelf(self);
    [_call accept:^(TILCallError *err)
    {
        if(err)
        {
            [weakself addTextToView:[NSString stringWithFormat:@"接受失败:%@-%d-%@", err.domain,err.code,err.errMsg]];
            [weakself selfDismiss];
        }
        else
        {
            [weakself addTextToView:@"接受成功"];
            
            [[ILiveRoomManager getInstance] setBeauty:3];
            [[ILiveRoomManager getInstance] setWhite:3];
            
            [self removeRecvChildVC];
            
            [weakself.headerView configHeaderView:self.liveItem];
        }
    }];
}
// 拒绝邀请
- (void)onRejectCall
{
    WCWeakSelf(self);
    [_call refuse:^(TILCallError *err)
     {
         if(err)
         {
             [weakself addTextToView:[NSString stringWithFormat:@"拒绝失败:%@-%d-%@", err.domain,err.code,err.errMsg]];
         }
         [weakself selfDismiss];
     }];
}

#pragma mark - 初始化容器
- (M8CallRenderModelManager *)modelManager
{
    if (!_modelManager)
    {
        M8CallRenderModelManager *modelManager = [[M8CallRenderModelManager  alloc] init];
        modelManager.WCDelegate     = self;
        modelManager.hostIdentify   = self.liveItem.info.host;
        modelManager.loginIdentify  = self.liveItem.uid;
        modelManager.callType       = self.liveItem.callType;
        _modelManager = modelManager;
    }
    return _modelManager;
}

- (M8CallHeaderView *)headerView
{
    if (!_headerView)
    {
        M8CallHeaderView *headerView = [[M8CallHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        headerView.WCDelegate = self;
        [self.view insertSubview:(_headerView = headerView) aboveSubview:self.renderView];
    }
    return _headerView;
}

- (M8MeetDeviceView *)deviceView
{
    if (!_deviceView)
    {
        M8MeetDeviceView *deviceView = [[M8MeetDeviceView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        [deviceView setCenterBtnImg:@"onMeetHangupCRed"];   //白底红按钮
//        [deviceView setCenterBtnImg:@"onMeetHangupRed"];    //红底白按钮
//        [deviceView setCenterBtnImg:@"onMeetHangup"];     //白底白按钮
        [self.view insertSubview:(_deviceView = deviceView) aboveSubview:self.renderView];
        
        
    }
    return _deviceView;
}

- (M8CallRenderView *)renderView
{
    if (!_renderView)
    {
        M8CallRenderView *renderView = [[M8CallRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) item:self.liveItem isHost:self.isHost];
        renderView.WCDelegate = self;
        [self.view insertSubview:(_renderView = renderView) aboveSubview:self.bgImageView];
    }
    return _renderView;
}

- (M8MenuPushView *)menuView
{
    if (!_menuView)
    {
        M8MenuPushView *menuView = [[M8MenuPushView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomHeight)
                                                               itemCount:self.liveItem.callType == TILCALL_TYPE_VIDEO ? 4 : 2
                                                                meetType:M8MeetTypeCall
                                    ];
        [self.view addSubview:menuView];
        [self.view bringSubviewToFront:menuView];
        _menuView = menuView;
    }
    return _menuView;
}
#pragma mark - createUI
- (void)createUI
{
    // 实现父类退出按钮的点击事件
    [self.exitButton addTarget:self action:@selector(selfDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self headerView];
    [self deviceView];
    [self renderView];
    [self menuView];
}



- (void)addTextToView:(id)newText
{
    [self.renderView addTextToView:newText];
}

- (void)selfDismiss
{
    BOOL ret = [M8UserDefault getPushMenuStatu];
    if (ret)
    {
        [self onHiddeMenuView];
        return ;
    }
    
    if (self.isHost)
    {
        [self onNetReportExitRoom];
        
        if (self.shouldHangup)
        {
            [self hangup];
        }
        else
        {
            [self cancelAllCall];
        }
    }
    else
    {
        [self onNetReportMemExitRoom];
        
        [self hangup];
    }
}


- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
}

@end
