//
//  M8CallViewController+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController+UI.h"

#import "M8MenuPushView.h"

#import "UserContactViewController.h"





@implementation M8CallViewController (UI)


#pragma mark - views delegate
#pragma mark -- MeetHeaderDelegate
- (void)MeetHeaderActionInfo:(NSDictionary *)actionInfo {
    
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
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:@(YES) forKey:kPushMenuStatus];
        [userD synchronize];
        
    }];
}

- (void)onHiddeMenuView
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.menuView.y = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:@(NO) forKey:kPushMenuStatus];
        [userD synchronize];
        
    }];
}

#pragma mark -- CallRenderDelegate
- (void)CallRenderActionInfo:(NSDictionary *)actionInfo
{
    [self addTextToView:[actionInfo allValues][0]];

    NSString *infoKey = [[actionInfo allKeys] firstObject];
    

    if ([infoKey isEqualToString:kCallAction])
    {
        NSString *infoValue = [actionInfo objectForKey:infoKey];
        if ([infoValue isEqualToString:@"inviteAction"])
        {   // 邀请更多成员
            UserContactViewController *contactVC = [[UserContactViewController alloc] init];
            contactVC.isExitLeftItem = YES;
            contactVC.contactType = ContactType_sel;
            [[AppDelegate sharedAppDelegate] pushViewController:contactVC];
        }
        if ([infoValue isEqualToString:@"touchesBegan"])
        {
            [self onHiddeMenuView];
        }
        
    }
}


#pragma mark -- RecvChildVCDelegate
- (void)RecvChildVCAction:(NSString *)actionStr
{
    if ([actionStr isEqualToString:@"reject"]) {
        [self onRejectCall];
    }
    else if ([actionStr isEqualToString:@"receive"]) {
        [self onReceiveCall];
    }
}


#pragma mark - UI相关
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.menuView.y == SCREEN_HEIGHT - kBottomHeight)
    {
        [self onHiddeMenuView];
    }
    
}



@end
