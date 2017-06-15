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
    
    if (self.callType == TILCALL_TYPE_VIDEO) {
        self.audioDeviceView.hidden = YES;
    }
    else if (self.callType == TILCALL_TYPE_AUDIO) {
        self.deviceView.hidden = YES;
    }
    
    [self.headerView configTopic:self.topic];
    
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
    baseConfig.callType = self.callType;
    baseConfig.isSponsor = YES;
    baseConfig.memberArray = self.membersArray;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self.renderView];
    [listener setNotifListener:self.renderView];
    [listener setCallStatusListener:self.renderView];
    
    config.callListener = listener;
    
    TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 15;
    sponsorConfig.callId = self.callId;
    sponsorConfig.onlineInvite = NO;
    config.sponsorConfig = sponsorConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    [_call createRenderViewIn:self.renderView];
    self.renderView.call = _call;
    self.renderView.hostIdentify = [[ILiveLoginManager getInstance] getLoginId];
    
    __weak typeof(self) ws = self;
    [_call makeCall:nil custom:self.topic result:^(TILCallError *err) {
        if(err){
            [ws addTextToView:[NSString stringWithFormat:@"呼叫失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
//            [ws selfDismiss];
        }
        else{
            [ws addTextToView:@"呼叫成功"];
            
            [[ILiveRoomManager getInstance] setBeauty:2];
            [[ILiveRoomManager getInstance] setWhite:2];
            
            [self.deviceView configButtonBackImgs];
            [self.audioDeviceView configButtonBackImgs];
            
            [self.headerView beginCountTime];
            
        }
    }];
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
    NSString *infoValue = [actionInfo objectForKey:infoKey];
    
    if ([infoKey isEqualToString:kCallAction]) {
        if ([infoValue isEqualToString:@"selfDismiss"]) {
            [_call hangup:nil];
            [self performSelector:NSSelectorFromString(infoValue) withObject:nil afterDelay:0];
        }
    }
    
    if ([infoKey isEqualToString:kCallValue]) {
        self.shouldHangup = [infoValue boolValue];
    }
}


- (void)deviceActionWithStr:(NSString *)actionStr {
    if ([actionStr isEqualToString:@"onHangupAction"]) {
        if (self.shouldHangup) {
            [self hangup];
        }
        else {
            [self cancelAllCall];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
