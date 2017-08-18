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
#import "M8CallViewController+AsyncListener.h"

#import "M8CallNoteModel.h"


@interface M8CallViewController ()

@end

@implementation M8CallViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self initCall];
    
    
    //隐藏菜单通知
    [WCNotificationCenter addObserver:self selector:@selector(onHiddeMenuView) name:kHiddenMenuView_Notifycation object:nil];
    //收到邀请成员通知
    [WCNotificationCenter addObserver:self selector:@selector(onReceiveInviteMembers) name:kInviteMembers_Notifycation object:nil];
    //收到App异常退出通知
    [WCNotificationCenter addObserver:self selector:@selector(selfDismiss) name:kAppWillTerminate_Notification object:nil];
    
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
    
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType            = self.liveItem.callType;
    baseConfig.isSponsor           = self.isHost && !self.isJoinSelf;
    baseConfig.memberArray         = self.liveItem.members;
    baseConfig.heartBeatInterval   = 15;
    baseConfig.isAutoResponseBusy  = YES;
    
    BOOL isVideo          = (self.liveItem.callType == TILCALL_TYPE_VIDEO);//如果是视频通话就自动打开相机
    baseConfig.autoCamera = isVideo;
    
    config.baseConfig = baseConfig;
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self];
    [listener setNotifListener:self];
    [listener setMsgListener:self];
    config.callListener = listener;
    
    if (self.isHost)
    {
        if (self.isJoinSelf)
        {
            [self joinSelfCall:config];
        }
        else
        {
            [self makeCall:config]; //创建会议需要在获取到会议ID之后创建，获取到会议ID只需要将成员信息上报给服务器之后才能返回，然后在tip中将会议ID传给接收端
        }
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
        self.curMid    = reportRoomData.mid;
        
        TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
        sponsorConfig.waitLimit             = 30;
        sponsorConfig.callId                = (int)self.liveItem.info.roomnum;
        sponsorConfig.onlineInvite          = NO;
        config.sponsorConfig                = sponsorConfig;
        
        self.call = [[TILMultiCall alloc] initWithConfig:config];
        [self.call createRenderViewIn:self.renderView];
        self.renderView.call = self.call;
        
        // 配置 customStr
        NSString *customStr = [NSString stringWithFormat:@"%@,%@", kGetStringFMInt(self.curMid), self.liveItem.info.title];
        
        WCWeakSelf(self);
        [_call makeCall:nil custom:customStr result:^(TILCallError *err) {
            
            if(err)
            {
                [weakself selfDismiss];
            }
            else
            {
                [weakself onNetSendCallNotify];
                
                [weakself menuView];
                
                [[ILiveRoomManager getInstance] setBeauty:2];
                [[ILiveRoomManager getInstance] setWhite:2];
                
                [weakself loadInvitedMembers];
                
                [weakself.headerView configHeaderView:self.liveItem.info.title host:self.liveItem.info.host];
                
                //开始推流
                [weakself onLivePushStart];
            }
        }];
    }];
}

- (void)joinSelfCall:(TILCallConfig *)config
{
    //    [self.renderModelManger memberJoinSelfWithID:self.liveItem.info.host];
    
    [self recvCall:config];
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


/**
 取消
 */
- (void)cancelAllCall
{
    [_call cancelAllCall:^(TILCallError *err) {
        if(err)
        {
            [super selfDismiss];
        }
        else
        {
            [super selfDismiss];
        }
    }];
}

/**
 挂断
 */
- (void)hangup
{
    [_call hangup:^(TILCallError *err)
     {
         if(err)
         {
             [super selfDismiss];
         }
         else
         {
             [super selfDismiss];
         }
     }];
}


- (void)inviteMembers:(NSArray *)membersArr
{
    // 配置 customStr
    NSString *customStr = [NSString stringWithFormat:@"%@,%@", kGetStringFMInt(self.curMid), self.liveItem.info.title];
    
    [self.call inviteCall:membersArr callTip:nil custom:customStr result:nil];
}

- (void)inviteMember:(NSString *)memberId
{
    [self inviteMembers:@[memberId]];
}


#pragma mark -- 接收方子视图相关
//添加接受子视图
- (void)addRecvChildVC
{
    _childVC            = [[M8RecvChildViewController alloc] init];
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
             [weakself selfDismiss];
         }
         else
         {
             [self menuView];
             
             [[ILiveRoomManager getInstance] setBeauty:3];
             [[ILiveRoomManager getInstance] setWhite:3];
             
             [weakself loadInvitedMembers];
             
             [self removeRecvChildVC];
             
             [weakself.headerView configHeaderView:self.liveItem.info.title host:self.liveItem.info.host];
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
             //             [weakself addTextToView:[NSString stringWithFormat:@"拒绝失败:%@-%d-%@", err.domain,err.code,err.errMsg]];
         }
         [weakself selfDismiss];
     }];
}

- (void)loadInvitedMembers
{
    [self.renderModelManger loadInvitedArray:[self.call getMembers]];
}

#pragma mark - 初始化容器
- (M8CallRenderModelManger *)renderModelManger
{
    if (!_renderModelManger)
    {
        M8CallRenderModelManger *renderModelManger = [[M8CallRenderModelManger alloc] initWithItem:self.liveItem];
        renderModelManger.WCDelegate               = self;
        _renderModelManger                         = renderModelManger;
    }
    return _renderModelManger;
}


- (M8CallHeaderView *)headerView
{
    if (!_headerView)
    {
        M8CallHeaderView *headerView          = [[M8CallHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        headerView.WCDelegate                 = self;
        [self.view insertSubview:(_headerView = headerView) aboveSubview:self.renderView];
    }
    return _headerView;
}

- (M8MeetDeviceView *)deviceView
{
    if (!_deviceView)
    {
        M8MeetDeviceView *deviceView = [[M8MeetDeviceView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate        = self;
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
        M8CallRenderView *renderView          = [[M8CallRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) item:self.liveItem isHost:self.isHost];
        renderView.WCDelegate                 = self;
        [self.view insertSubview:(_renderView = renderView) aboveSubview:self.bgImageView];
    }
    return _renderView;
}

- (M8CallRenderNote *)noteView
{
    if (!_noteView)
    {
        M8CallRenderNote *noteView       = [[M8CallRenderNote alloc] initWithFrame:CGRectMake(kDefaultMargin, self.view.height - kBottomHeight - kNoteViewHeight - kDefaultMargin, kNoteViewWidth, kNoteViewHeight)];
        [self.view addSubview:(_noteView = noteView)];
    }
    return _noteView;
}

- (M8MenuPushView *)menuView
{
    if (!_menuView)
    {
        M8MenuPushView *menuView = [[M8MenuPushView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomHeight)
                                                               itemCount:self.liveItem.callType == TILCALL_TYPE_VIDEO ? 5 : 3
                                                                meetType:M8MeetTypeCall
                                                                    call:self.call
                                    ];
        menuView.WCDelegate = self;
        [self.view addSubview:menuView];
        [self.view bringSubviewToFront:menuView];
        _menuView = menuView;
    }
    return _menuView;
}

- (M8NoteToolBar *)noteToolBar
{
    if (!_noteToolBar)
    {
        M8NoteToolBar *noteToolBar = [[M8NoteToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kDefaultCellHeight, SCREEN_WIDTH, kDefaultCellHeight)];
        noteToolBar.hidden         = YES;
        noteToolBar.WCDelegate     = self;
        [self.view addSubview:noteToolBar];
        [self.view bringSubviewToFront:noteToolBar];
        _noteToolBar = noteToolBar;
    }
    return _noteToolBar;
}



#pragma mark - createUI
- (void)createUI
{
    // 实现父类退出按钮的点击事件
    [self.exitButton addTarget:self action:@selector(selfDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self headerView];
    [self deviceView];
    [self renderView];
    [self noteView];
    //    [self menuView];
    [self noteToolBar]; //初始化时是隐藏的
}

#pragma mark -- 添加 noteView 数据
- (void)addMember:(NSString *)member withTip:(NSString *)tip
{
    M8CallNoteModel *model = [[M8CallNoteModel alloc] initWithMember:member tip:tip];
    [self.noteView loadItemsArray:model];
}

- (void)addMember:(NSString *)member withMsg:(NSString *)msg
{
    M8CallNoteModel *model = [[M8CallNoteModel alloc] initWithMember:member msg:msg];
    [self.noteView loadItemsArray:model];
}


- (void)selfDismiss
{
    [self onNetReportExitRoom];
    
    if (self.isHost &&
        !self.shouldHangup &&
        !self.isJoinSelf)
    {
        [self cancelAllCall];
    }
    else
    {
        [self hangup];
    }
}


- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
    [WCNotificationCenter removeObserver:self name:kInviteMembers_Notifycation object:nil];
    [WCNotificationCenter removeObserver:self name:kAppWillTerminate_Notification object:nil];
}

@end
