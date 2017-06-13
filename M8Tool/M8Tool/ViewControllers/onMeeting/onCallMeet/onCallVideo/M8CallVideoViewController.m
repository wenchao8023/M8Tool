//
//  M8CallVideoViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallVideoViewController.h"



@interface M8CallVideoViewController ()

@end



@implementation M8CallVideoViewController
@synthesize _call;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = YES;
    baseConfig.memberArray = self.membersArray;
    baseConfig.heartBeatInterval = 0;
    config.baseConfig = baseConfig;
    
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self.renderView];
    [listener setNotifListener:self.renderView];
    [listener setCallStatusListener:self.renderView];
    
    config.callListener = listener;
    
    TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 0;
    sponsorConfig.callId = self.callId; 
    sponsorConfig.onlineInvite = NO;
    config.sponsorConfig = sponsorConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    // 赋值给 renderView
    self.renderView.call = _call;
    
    [_call createRenderViewIn:self.renderView];
    __weak typeof(self) ws = self;
    [_call makeCall:nil custom:nil result:^(TILCallError *err) {
        if(err){
             [ws addTextToView:[NSString stringWithFormat:@"呼叫失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [ws selfDismiss];
        }
        else{
            [ws addTextToView:@"呼叫成功"];
            
//            [[ILiveRoomManager getInstance] setBeauty:5];
//            [[ILiveRoomManager getInstance] setWhite:5];
            
            [self.deviceView configButtonBackImgs];
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
