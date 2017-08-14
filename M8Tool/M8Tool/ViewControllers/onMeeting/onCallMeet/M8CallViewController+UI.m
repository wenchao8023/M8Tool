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
//                TILCallNotification *disNotify = [[TILCallNotification alloc] init];
//                disNotify.callId = [self.call getCallId];
//                disNotify.notifId = TILCALL_NOTIF_DISCONNECT;
//                disNotify.sender = self.liveItem.uid;
//                disNotify.targets = [self.renderModelManger onGetOnLineMembers];
//                [self.call postNotification:disNotify result:nil];
            }
                break;
            case kOnDeviceActionNote:
            {
//                [self addTextToView:@"点击发言"];
                [self onNoteAction];
            }
                break;
            case kOnDeviceActionCenter:
            {
                [self selfDismiss];
            }
                break;
            case kOnDeviceActionMenu:
            {
                [self onMenuAction];
            }
                break;
            case kOnDeviceActionSwichRender:
            {
                [self showFloatView];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)onShareAction
{
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"share2017.png"]];
//    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"wc 是sb"
//                                           type:SSDKContentTypeAuto];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK share:SSDKPlatformTypeWechat parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//            
//        }];
//    }
    
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
}

- (void)onNoteAction
{
    [self.noteToolBar onBeginEditingAction];
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
    NSString *infoKey = [[actionInfo allKeys] firstObject];

    if ([infoKey isEqualToString:kCallAction])
    {
         id infoValue = [actionInfo objectForKey:infoKey];
        
        if ([infoValue isKindOfClass:[NSDictionary class]])
        {
            NSString *subKey = [[infoValue allKeys] firstObject];
            //添加
            if ([subKey isEqualToString:@"invite"])
            {
                NSString *inviteId = [infoValue objectForKey:@"invite"];
                [self inviteMember:inviteId];
                
                [self.renderModelManger memberUserAction:inviteId onAction:subKey];
            }
            //移除
            if ([subKey isEqualToString:@"remove"])
            {
                NSString *inviteId = [infoValue objectForKey:@"remove"];
                
                [self.renderModelManger memberUserAction:inviteId onAction:subKey];
            }
        }
    }
}


#pragma mark -- MenuPushDelegate
- (void)MenuPushActionInfo:(NSDictionary *)info
{    
    NSString *infoKey = [[info allKeys] firstObject];
    NSString *infoValue = [info objectForKey:infoKey];
    
    if ([infoKey isEqualToString:kMenuPushAction])
    {
        if ([infoValue isEqualToString:@"onInviteAction"])
        {
            [self onInviteAction];// 邀请更多成员
        }
    }
    if ([infoKey isEqualToString:kMenuPushText])
    {
        if ([infoValue isKindOfClass:[NSString class]])
        {
            [self addMember:nil withTip:infoValue];
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
    contactVC.contactType = ContactType_invite;
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


#pragma mark -- M8NoteToolBarDelegate
- (void)noteToolBarOriginY:(CGFloat)originY isHidden:(BOOL)ishidden animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)curve
{
    CGRect noteFrame;
    if (ishidden)
    {
        noteFrame = CGRectMake(kDefaultMargin, self.view.height - kBottomHeight - kNoteViewHeight - kDefaultMargin, kNoteViewWidth, kNoteViewHeight);
    }
    else
    {
        CGFloat itemWidth  = (SCREEN_WIDTH - 50) / 4;
        CGFloat itemHeight = itemWidth * 5 / 3;
        
        CGFloat noteHeight = originY - (70 + itemHeight);

        if (noteHeight > 120)
        {
            noteHeight = 120;
        }
        else if (noteHeight < 0)
        {
            noteHeight = 40;
        }
        
        noteFrame = CGRectMake(kDefaultMargin, originY - noteHeight, kNoteViewWidth, noteHeight);
    }
    
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    self.noteView.frame = noteFrame;
    self.noteToolBar.y  = originY;
    [UIView commitAnimations];
    
    [self.noteView reloadData];
}


- (void)noteToolBarSendMsg:(NSString *)msg
{
    [self sendOnlineMsg:msg];
}

- (void)sendOnlineMsg:(NSString *)msg
{
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    textElem.text = msg;
    
    TIMMessage *TIMMsg = [[TIMMessage alloc] init];
    [TIMMsg setPriority:TIM_MSG_PRIORITY_NORMAL];
    
    int elemCount = [TIMMsg addElem:textElem];
    
    if (elemCount == 1)
    {
        [AlertHelp tipWith:@"消息错误，核对后输入" wait:1];
        return ;
    }
    
    NSString *groupId = self.liveItem.info.groupid;
    
    TIMManager *imManger = [[ILiveSDK getInstance] getTIMManager];
    
    TIMConversation *imConv = [imManger getConversation:TIM_GROUP receiver:groupId];
    
    [self addMember:@"我" withMsg:msg];
    
    WCWeakSelf(self);
    [imConv sendOnlineMessage:TIMMsg succ:^{
    
        
    } fail:^(int code, NSString *msg) {
        
        [weakself sendOnlineMsg:msg];
    }];
}


#pragma mark - UI相关
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    if ([M8UserDefault getKeyboardShow])
    {
        [WCNotificationCenter postNotificationName:kHiddenKeyboard_Notifycation object:nil];
        return ;
    }
    
    if (self.menuView.y == SCREEN_HEIGHT - kBottomHeight)
    {
        [self onHiddeMenuView];
    }
}

#pragma mark - super action
- (void)showFloatView
{
    [self.floatView configCallFloatView:[self.renderModelManger toNickWithUid:self.liveItem.info.host] callType:self.liveItem.callType cameraOn:[self.renderModelManger onGetHostCameraStatu]];
    
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
        [self.renderModelManger onBackFromFloatView];
    }];
}

@end
