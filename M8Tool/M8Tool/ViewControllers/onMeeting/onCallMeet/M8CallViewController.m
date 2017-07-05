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

@interface M8CallViewController ()

@end

@implementation M8CallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self initCall];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCall
{
    if (self.isHost)
        [self makeCall];
    else
        [self recvCall];
}

- (void)makeCall
{
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = self.liveItem.callType;
    baseConfig.isSponsor = YES;
    baseConfig.memberArray = self.liveItem.members;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self];
    [listener setNotifListener:self];
    
    config.callListener = listener;
    
    TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 30;
    sponsorConfig.callId = (int)self.liveItem.info.roomnum;
    sponsorConfig.onlineInvite = NO;
    config.sponsorConfig = sponsorConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    [_call createRenderViewIn:self.renderView];
    self.renderView.call = _call;
    
    __weak typeof(self) ws = self;
    [_call makeCall:nil custom:self.liveItem.info.title result:^(TILCallError *err) {
        if(err){
            [ws addTextToView:[NSString stringWithFormat:@"呼叫失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
//            [ws selfDismiss];
        }
        else{
            [ws addTextToView:@"呼叫成功"];
            
            [[ILiveRoomManager getInstance] setBeauty:2];
            [[ILiveRoomManager getInstance] setWhite:2];
            
//            [self.deviceView configButtonBackImgs];
//            [self.audioDeviceView configButtonBackImgs];
            
//            [self.headerView beginCountTime];
            
            [ws onNetReportRoomInfo];
        }
    }];
}

- (void)recvCall
{
    
}

/**
 取消
 */
- (void)cancelAllCall {
    WCWeakSelf(self);
    [_call cancelAllCall:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"取消失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
//            [weakself selfDismiss];
            [weakself cancelAllCall];
        }
        else{
            [weakself addTextToView:@"取消成功"];
            [weakself selfDismiss];
        }
    }];
}

/**
 挂断
 */
- (void)hangup {
    WCWeakSelf(self);
    [_call hangup:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"挂断失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
//            [weakself selfDismiss];
            [weakself hangup];
        }
        else{
            [weakself addTextToView:@"挂断成功"];
            [weakself selfDismiss];
        }
    }];
}


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

#pragma mark - createUI
- (void)createUI
{
    [self headerView];
    [self deviceView];
    [self.view insertSubview:self.renderView aboveSubview:self.bgImageView];
}

- (M8CallHeaderView *)headerView
{
    if (!_headerView)
    {
        M8CallHeaderView *headerView = [[M8CallHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        headerView.WCDelegate = self;
        [self.view addSubview:(_headerView = headerView)];
    }
    return _headerView;
}

- (M8DeviceView *)deviceView
{
    if (!_deviceView)
    {
        M8DeviceView *deviceView = [[M8DeviceView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight - kDefaultMargin, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        [self.view addSubview:(_deviceView = deviceView)];
    }
    return _deviceView;
}

- (M8CallRenderView *)renderView
{
    if (!_renderView)
    {
        M8CallRenderView *renderView = [[M8CallRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) item:self.liveItem isHost:self.isHost];
        renderView.WCDelegate = self;
        [self.view addSubview:(_renderView = renderView)];
    }
    return _renderView;
}

- (void)addTextToView:(id)newText
{
    [self.renderView addTextToView:newText];
}

- (void)selfDismiss
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
@end
