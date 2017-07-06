//
//  M8MakeCallViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MakeCallViewController.h"

@interface M8MakeCallViewController ()

@property (nonatomic, assign) BOOL shouldHangup;

@end

@implementation M8MakeCallViewController
@synthesize _call;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isHost = YES;

    if (_liveItem.callType == TILCALL_TYPE_VIDEO) {
        self.audioDeviceView.hidden = YES;
    }
    else if (_liveItem.callType == TILCALL_TYPE_AUDIO) {
        self.deviceView.hidden = YES;
    }
    
    [self.headerView configTopic:_liveItem.info.title];
    
    [self makeCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 通话接口相关
- (void)makeCall {
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = _liveItem.callType;
    baseConfig.isSponsor = YES;
    baseConfig.memberArray = _liveItem.members;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self.renderView];
    [listener setNotifListener:self.renderView];
    [listener setCallStatusListener:self.renderView];
    
    config.callListener = listener;
    
    TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 30;
    sponsorConfig.callId = (int)_liveItem.info.roomnum;
    sponsorConfig.onlineInvite = NO;
    config.sponsorConfig = sponsorConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    [_call createRenderViewIn:self.renderView];
    self.renderView.call = _call;
    self.renderView.hostIdentify = [[ILiveLoginManager getInstance] getLoginId];
    
    __weak typeof(self) ws = self;
    [_call makeCall:nil custom:_liveItem.info.title result:^(TILCallError *err) {
        if(err){
            [ws addTextToView:[NSString stringWithFormat:@"呼叫失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [ws selfDismiss];
        }
        else{
            [ws addTextToView:@"呼叫成功"];
            
            [[ILiveRoomManager getInstance] setBeauty:2];
            [[ILiveRoomManager getInstance] setWhite:2];
            
            [self.deviceView configButtonBackImgs];
            [self.audioDeviceView configButtonBackImgs];
            
            [self.headerView beginCountTime];
            
            [self reportRoomInfo:(int)_liveItem.info.roomnum groupId:_liveItem.info.groupid];
        }
    }];
}

- (void)reportRoomInfo:(int)roomId groupId:(NSString *)groupid
{
    WCWeakSelf(self);
    __block ReportRoomResponseData *reportRoomData = nil;
    ReportRoomRequest *reportReq = [[ReportRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
        reportRoomData = (ReportRoomResponseData *)request.response.data;
        weakself.renderView.mid = reportRoomData.mid;
//        [weakself addTextToView:[NSString stringWithFormat:@"%d", reportRoomData.mid]];
        [weakself addTextToView:@"上报房间信息成功"];
    } failHandler:^(BaseRequest *request) {
        // 上传失败
        [weakself addTextToView:@"上报房间信息失败"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errinfo = [NSString stringWithFormat:@"code=%ld,msg=%@",(long)request.response.errorCode,request.response.errorInfo];
            [AlertHelp alertWith:@"上传RoomInfo失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        });
    }];
    
    reportReq.token = [AppDelegate sharedAppDelegate].token;
    reportReq.members = _liveItem.members;
    reportReq.room = [[ShowRoomInfo alloc] init];
    reportReq.room.title = _liveItem.info.title;
    reportReq.room.type = _liveItem.info.type;
    reportReq.room.roomnum = roomId;
    reportReq.room.groupid = [NSString stringWithFormat:@"%d",roomId];
    reportReq.room.appid = [ShowAppId intValue];
    
    [[WebServiceEngine sharedEngine] asyncRequest:reportReq];
}


- (void)cancelAllCall {
    WCWeakSelf(self);
    [_call cancelAllCall:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"取消失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [weakself selfDismiss];
        }
        else{
            [weakself addTextToView:@"取消成功"];
            [weakself selfDismiss];
        }
    }];
}

- (void)hangup {
    WCWeakSelf(self);
    [_call hangup:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"挂断失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [weakself selfDismiss];
        }
        else{
            [weakself addTextToView:@"挂断成功"];
            [weakself selfDismiss];
        }
    }];
}


#pragma mark - views delegate
#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [super MeetDeviceActionInfo:actionInfo];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    NSString *infoValue = [actionInfo objectForKey:infoKey];
    if ([infoKey isEqualToString:kDeviceAction]) {
        [self deviceActionWithStr:infoValue];
    }
    else {
        
    }
}

#pragma mark -- CallAudioDeviceDelegate
- (void)CallAudioDeviceActionInfo:(NSDictionary *)actionInfo {
    [super CallAudioDeviceActionInfo:actionInfo];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    NSString *infoValue = [actionInfo objectForKey:infoKey];
    if ([infoKey isEqualToString:kCallAudioDeviceAction]) {
        [self deviceActionWithStr:infoValue];
    }
    else {
        
    }
}

#pragma mark -- CallRenderDelegate
- (void)CallRenderActionInfo:(NSDictionary *)actionInfo {
    
    [super CallRenderActionInfo:actionInfo];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];

    if ([infoKey isEqualToString:kCallAction]) {
        NSString *infoValue = [actionInfo objectForKey:infoKey];
        if ([infoValue isEqualToString:@"selfDismiss"]) {
            [_call hangup:nil];
            [self performSelector:NSSelectorFromString(infoValue) withObject:nil afterDelay:0];
        }
    }
    
    if ([infoKey isEqualToString:kCallValue_bool]) {
        NSString *infoValue = [actionInfo objectForKey:infoKey];
        self.shouldHangup = [infoValue boolValue];
    }
}


- (void)deviceActionWithStr:(NSString *)actionStr
{
    if ([actionStr isEqualToString:@"onHangupAction"])
    {
        
        //通知业务服务器，退房
        ExitRoomRequest *exitReq = [[ExitRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
            NSLog(@"上报退出房间成功");
        } failHandler:^(BaseRequest *request) {
            NSLog(@"上报退出房间失败");
        }];
        
        exitReq.token = [AppDelegate sharedAppDelegate].token;
        exitReq.roomnum = _liveItem.info.roomnum;
        exitReq.type = _liveItem.info.type;
        
        [[WebServiceEngine sharedEngine] asyncRequest:exitReq wait:NO];
        
        if (self.shouldHangup)
        {
            [self hangup];
        }
        else
        {
            [self cancelAllCall];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
