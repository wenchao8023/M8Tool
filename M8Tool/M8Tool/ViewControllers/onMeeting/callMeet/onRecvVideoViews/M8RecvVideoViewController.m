//
//  M8RecvVideoViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecvVideoViewController.h"

#import "M8CallVideoRenderView.h"


@interface M8RecvVideoViewController ()<CallVideoRenderDelegate>

@property (nonatomic, strong) TILMultiCall *call;

@property (nonatomic, strong) M8CallVideoRenderView *renderView;

@end


@implementation M8RecvVideoViewController
#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self initCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面相关
- (M8CallVideoRenderView *)renderView {
    if (!_renderView) {
        M8CallVideoRenderView *renderView = [[M8CallVideoRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
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
    
    // 接受邀请
    WCWeakSelf(self);
    [_call accept:^(TILCallError *err) {
        if(err){
            [weakself addTextToView:[NSString stringWithFormat:@"接受失败:%@-%d-%@",err.domain,err.code,err.errMsg]];
            [weakself selfDismiss];
        }
        else{
            
            [weakself addTextToView:@"接受成功"];
        }
    }];
}

#pragma mark - views delegate
#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    if ([infoKey isEqualToString:kDeviceAction]) {
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"quitRoomSucc"]) {
            [self.call hangup:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self addTextToView:actionInfo[infoKey]];
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
        if ([[actionInfo objectForKey:infoKey] isEqualToString:@"dismiss"]) {
            [self.call hangup:nil];
            //            [self selfDismiss];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
