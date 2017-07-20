//
//  M8CallViewController+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController+UI.h"

#import "UserContactViewController.h"





@implementation M8CallViewController (UI)


#pragma mark - views delegate
#pragma mark -- MeetHeaderDelegate
- (void)MeetHeaderActionInfo:(NSDictionary *)actionInfo
{
    
}


#pragma mark -- M8DeviceDelegate
- (void)M8MeetDeviceViewActionInfo:(NSDictionary *)actionInfo
{
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    if ([infoKey isEqualToString:kDeviceAction])
    {
        kOnDeviceAction deviceAction = [[actionInfo objectForKey:kDeviceAction] integerValue];
        switch (deviceAction) {
            case kOnDeviceActionShare:
            {
                [self addTextToView:@"点击分享"];
            }
                break;
            case kOnDeviceActionNote:
            {
                [self addTextToView:@"点击发言"];
            }
                break;
            case kOnDeviceActionCenter:
            {
                [self addTextToView:@"点击挂断"];
                [self selfDismiss];
            }
                break;
            case kOnDeviceActionMenu:
            {
                [self addTextToView:@"点击菜单"];
                [self onMenuAction];
            }
                break;
            case kOnDeviceActionSwichRender:
            {
                [self addTextToView:@"缩小视图"];
                [self showFloatView];
            }
                break;
                
            default:
                break;
        }
    }
}

//推出底部菜单之后，要通知这个界面上的所有点击事件（自身除外）
//点击的时候应该收起底部菜单
- (void)onMenuAction
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.menuView.y = SCREEN_HEIGHT - kBottomHeight;
        
    } completion:^(BOOL finished) {
        
        // 保存菜单推出状态到本地
        [M8UserDefault setPushMenuStatu:YES];
        
    }];
}

- (void)onHiddeMenuView
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.menuView.y = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        
        [M8UserDefault setPushMenuStatu:NO];
    }];
}

#pragma mark -- CallRenderDelegate
- (void)CallRenderActionInfo:(NSDictionary *)actionInfo
{
    [self addTextToView:[actionInfo allValues][0]];

    NSString *infoKey = [[actionInfo allKeys] firstObject];
    

    if ([infoKey isEqualToString:kCallAction])
    {
         id infoValue = [actionInfo objectForKey:infoKey];
        
        if ([infoValue isKindOfClass:[NSDictionary class]])
        {
            NSString *subKey = [[infoValue allKeys] firstObject];
            if ([subKey isEqualToString:@"invite"])
            {
                NSString *inviteId = [infoValue objectForKey:@"invite"];
                [self inviteMember:inviteId];
                
                [self.renderModelManger memberUserAction:inviteId onAction:subKey];
            }
        }
    }
}


#pragma mark -- MenuPushDelegate
- (void)MenuPushActionInfo:(NSDictionary *)info
{
    [self addTextToView:[info allValues][0]];
    
    NSString *infoKey = [[info allKeys] firstObject];
    
    if ([infoKey isEqualToString:kMenuPushAction])
    {
        NSString *infoValue = [info objectForKey:infoKey];
        if ([infoValue isEqualToString:@"onInviteAction"])
        {
            [self onInviteAction];// 邀请更多成员
        }
    }
}




/**
 在会议中推出联系人界面的时候需要将会议界面换成小视图
 */
- (void)onInviteAction
{
    [self showFloatView];
    
    UserContactViewController *contactVC = [[UserContactViewController alloc] init];
    contactVC.isExitLeftItem = YES;
    contactVC.contactType = ContactType_sel;
    [[AppDelegate sharedAppDelegate] pushViewController:contactVC];
}


#pragma mark -- RecvChildVCDelegate
- (void)RecvChildVCAction:(NSString *)actionStr
{
    if ([actionStr isEqualToString:@"reject"])
    {
        [self onRejectCall];
    }
    else if ([actionStr isEqualToString:@"receive"])
    {
        [self onReceiveCall];
    }
}

#pragma mark -- M8FloatViewDelegate
- (void)M8FloatView:(id)floatView centerChanged:(CGPoint)center
{
    self.floatView = floatView;
    self.floatView.superview.center = center;
    
    [self modifyHostRenderViewInFloatView:center];
}

- (void)M8FloatView:(id)floatView centerEnded:(CGPoint)center
{
    self.floatView = floatView;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.floatView.superview.center = center;
        [self modifyHostRenderViewInFloatView:center];
    }];
}

- (void)modifyHostRenderViewInFloatView:(CGPoint)center
{
    CGRect curFrame = CGRectMake(0, 0, kFloatWindowWidth, kFloatWindowHeight);
    curFrame.origin.x = center.x - kFloatWindowWidth / 2;
    curFrame.origin.y = center.y - kFloatWindowHeight / 2 - SCREEN_HEIGHT;
    
    ILiveRenderView *hostRV = [self.call getRenderFor:self.liveItem.info.host];
    hostRV.frame = curFrame;
}

#pragma mark - UI相关
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.menuView.y == SCREEN_HEIGHT - kBottomHeight)
    {
        [self onHiddeMenuView];
    }
}

#pragma mark - super action
- (void)showFloatView
{
//    [self.floatView configCallFloatView:self.liveItem isCameraOn:[self.modelManager onGetHostCameraStatu]];
    [self.floatView configCallFloatView:self.liveItem isCameraOn:[self.renderModelManger onGetHostCameraStatu]];
    
    [super showFloatView];
    
    // 1. 将通话界面移动到视图底部，移出手机界面
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        // 2. 显示浮动窗口
        self.floatView.hidden = NO;
        // 3. 重新设置视频流位置
        [self modifyHostRenderViewInFloatView:self.floatView.superview.center];
    }];
}

- (void)hiddeFloatView
{
    [super hiddeFloatView];
    
    // 1. 隐藏浮动窗口
    self.floatView.hidden = YES;
    // 2. 将通话界面从底部移动到手机视图
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        // 3. 应该要通知 通话界面 重新刷新位置
//        [self.modelManager onBackFromFloatView];
        [self.renderModelManger onBackFromFloatView];
    }];
}



@end
