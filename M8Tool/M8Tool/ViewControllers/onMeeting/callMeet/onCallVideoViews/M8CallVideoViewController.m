//
//  M8CallVideoViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallVideoViewController.h"

#import "M8CallVideoRenderView.h"

@interface M8CallVideoViewController ()<CallVideoRenderDelegate>

@property (nonatomic, strong) TILMultiCall *call;

@property (nonatomic, strong) M8CallVideoRenderView *renderView;

@end

@implementation M8CallVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self makeCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面相关
- (M8CallVideoRenderView *)renderView {
    if (!_renderView) {
        M8CallVideoRenderView *renderView = [[M8CallVideoRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
        renderView.WCDelegate = self;
        [self.view insertSubview:(_renderView = renderView) aboveSubview:self.bgImageView];
    }
    return _renderView;
}

- (void)createUI {
    [self bgImageView];
    [self renderView];
    [self headerView];
    [self deviceView];
}

#pragma mark - 通话接口相关
- (void)makeCall {
    TILCallConfig * config = [[TILCallConfig alloc] init];
    TILCallBaseConfig * baseConfig = [[TILCallBaseConfig alloc] init];
    baseConfig.callType = TILCALL_TYPE_VIDEO;
    baseConfig.isSponsor = YES;
    baseConfig.memberArray = self.membersArray;
    baseConfig.heartBeatInterval = 15;
    config.baseConfig = baseConfig;
    
    
    TILCallListener * listener = [[TILCallListener alloc] init];
    [listener setMemberEventListener:self.renderView];
    [listener setNotifListener:self.renderView];
    
    config.callListener = listener;
    
    TILCallSponsorConfig *sponsorConfig = [[TILCallSponsorConfig alloc] init];
    sponsorConfig.waitLimit = 0;
    sponsorConfig.callId = self.callId; //(int)([[NSDate date] timeIntervalSince1970]) % 1000 * 1000 + arc4random() % 1000;
    sponsorConfig.onlineInvite = NO;
    config.sponsorConfig = sponsorConfig;
    
    _call = [[TILMultiCall alloc] initWithConfig:config];
    
    [_call createRenderViewIn:self.renderView];
    __weak typeof(self) ws = self;
    [_call makeCall:nil custom:nil result:^(TILCallError *err) {
        if(err){
            [ws addTextToView:[NSString stringWithFormat:@"呼叫失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [ws selfDismiss];
        }
        else{
            [ws addTextToView:@"呼叫成功"];
            
            [[ILiveRoomManager getInstance] setBeauty:5];
            [[ILiveRoomManager getInstance] setWhite:5];
        }
    }];
}

#pragma mark - views delegate
#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    if ([infoKey isEqualToString:kDeviceAction]) {
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"onHangupAction"]) {
            [self.call hangup:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        
    }
}

#pragma mark -- CallVideoRenderDelegate
- (void)CallVideoRenderActionInfo:(NSDictionary *)actionInfo {
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    NSString *infoValue = [actionInfo objectForKey:infoKey];
    
    [self addTextToView:infoValue];
    
    if ([infoKey isEqualToString:kCallAction]) {
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"selfDismiss"]) {
            [self.call hangup:nil];
            [self performSelector:NSSelectorFromString(infoValue) withObject:nil afterDelay:1];
        }
        else {
            [self addTextToView:actionInfo[infoKey]];
        }
    }
}

#pragma mark - actions
- (void)addTextToView:(NSString *)newText {
    [self.renderView addTextToView:newText];
}

- (void)selfDismiss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}



@end
