//
//  M8RecvVideoViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecvVideoViewController.h"


@interface M8RecvVideoViewController ()

@end


@implementation M8RecvVideoViewController
@synthesize _call;
#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通话接口相关
- (void)initCall{
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = NO;
    baseConfig.memberArray = _invitation.memberArray;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self.renderView];
    [listener setNotifListener:self.renderView];
    
    config.callListener = listener;
    
    TILCallResponderConfig * responderConfig = [[TILCallResponderConfig alloc] init];
    responderConfig.callInvitation = _invitation;
    config.responderConfig = responderConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    [_call createRenderViewIn:self.renderView];
    self.renderView.call = _call;
    self.renderView.hostIdentify = _invitation.sponsorId;
    
    // 接受邀请
    WCWeakSelf(self);
    [_call accept:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"接受失败:%@-%d-%@", err.domain,err.code,err.errMsg]];
            [weakself selfDismiss];
        }
        else{
            
            [weakself addTextToView:@"接受成功"];
            
//            TILCallNotification *acceptSuccNotify = [TILCallNotification new];
//            acceptSuccNotify.notifId = TILCALL_NOTIF_ACCEPTED;
//            acceptSuccNotify.sender  = [[ILiveLoginManager getInstance] getLoginId];
//            acceptSuccNotify.targets = weakself.invitation.memberArray;
//            [weakself._call postNotification:acceptSuccNotify result:^(TILCallError *err) {
//                if (err) {
//                    [weakself addTextToView:[NSString stringWithFormat:@"domain: %@, code: %d, msg: %@", err.domain, err.code, err.errMsg]];
//                }
//                else {
//                    [weakself addTextToView:@"发送通知成功"];
//                }
//            }];
            
            [weakself.deviceView configButtonBackImgs];
            
            [[ILiveRoomManager getInstance] setBeauty:3];
            [[ILiveRoomManager getInstance] setWhite:3];
        }
    }];
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
