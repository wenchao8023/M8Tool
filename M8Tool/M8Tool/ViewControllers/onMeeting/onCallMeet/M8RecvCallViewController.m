//
//  M8RecvCallViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecvCallViewController.h"
#import "M8RecvChildViewController.h"

@interface M8RecvCallViewController ()<RecvChildVCDelegate>
{
    M8RecvChildViewController *_childVC;
}

@end

@implementation M8RecvCallViewController
@synthesize _call;

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initCall];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    TILCallType callType = [_call getCallType];
    if (callType == TILCALL_TYPE_VIDEO) {
        self.audioDeviceView.hidden = YES;
    }
    else if (callType == TILCALL_TYPE_AUDIO) {
        self.deviceView.hidden = YES;
    }
    
    _childVC = [[M8RecvChildViewController alloc] init];
    _childVC.invitation = self.invitation;
    _childVC.WCDelegate = self;
    _childVC.view.frame = self.view.bounds;
    [self addChildViewController:_childVC];
    [self.view addSubview:_childVC.view];
    [_childVC didMoveToParentViewController:self];
}


- (void)RecvChildVCAction:(NSString *)actionStr {
    if ([actionStr isEqualToString:@"reject"]) {
        [self onRejectCall];
    }
    else if ([actionStr isEqualToString:@"receive"]) {
        [self onReceiveCall];
    }
}

- (void)removeChildViewController {
    [_childVC willMoveToParentViewController:nil];
    [_childVC.view removeFromSuperview];
    [_childVC removeFromParentViewController];
}

- (void)onRejectCall {
    
    WCWeakSelf(self);
    [_call refuse:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"拒绝失败:%@-%d-%@", err.domain,err.code,err.errMsg]];
        }
        [weakself selfDismiss];
    }];
}
// 接受邀请
- (void)onReceiveCall {
    WCWeakSelf(self);
    [_call accept:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"接受失败:%@-%d-%@", err.domain,err.code,err.errMsg]];
//            [weakself selfDismiss];
        }
        else{
            
            [weakself addTextToView:@"接受成功"];
            [weakself.deviceView configButtonBackImgs];
            [self.audioDeviceView configButtonBackImgs];
            
            [[ILiveRoomManager getInstance] setBeauty:3];
            [[ILiveRoomManager getInstance] setWhite:3];
            
            [self removeChildViewController];
        }
    }];
}

#pragma mark - 通话接口相关
- (void)initCall{
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = _invitation.callType;
    baseConfig.isSponsor = NO;
    baseConfig.memberArray = _invitation.memberArray;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self.renderView];
    [listener setNotifListener:self.renderView];
    [listener setCallStatusListener:self.renderView];
    
    config.callListener = listener;
    
    TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
    responderConfig.callInvitation = _invitation;
    config.responderConfig = responderConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    [_call createRenderViewIn:self.renderView];
    self.renderView.call = _call;
    self.renderView.hostIdentify = _invitation.sponsorId;
}

#pragma mark - views delegate
#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [super MeetDeviceActionInfo:actionInfo];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    if ([infoKey isEqualToString:kDeviceAction]) {
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"onHangupAction"]) {
            [_call hangup:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        
    }
}

#pragma mark -- CallAudioDeviceDelegate
- (void)CallAudioDeviceActionInfo:(NSDictionary *)actionInfo {
    [super CallAudioDeviceActionInfo:actionInfo];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    if ([infoKey isEqualToString:kCallAudioDeviceAction]) {
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"onHangupAction"]) {
            [_call hangup:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self addTextToView:actionInfo[infoKey]];
        }
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
        else {
            [self addTextToView:actionInfo[infoKey]];
        }
    }
}
@end
