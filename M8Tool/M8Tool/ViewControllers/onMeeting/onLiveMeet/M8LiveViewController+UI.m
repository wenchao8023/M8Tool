//
//  M8LiveViewController+UI.m
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveViewController+UI.h"

@implementation M8LiveViewController (UI)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:kPushMenuStatus];
    if (ret)
    {
        [self onHiddeMenuView];
    }
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
                [self addTextToView:@"点击菜单"];
                [self onMenuAction];
            }
                break;
            case kOnDeviceActionMenu:
            {
                [self addTextToView:@"点击私信"];
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
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    ILiveRenderView *hostRV = [manager getAVRenderView:self.liveItem.info.host srcType:QAVVIDEO_SRC_TYPE_CAMERA];
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
    [super showFloatView];
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    NSArray *avRVArray = [manager getAllAVRenderViews];
    ILiveRenderView *hostRV = [manager getAVRenderView:self.liveItem.info.host srcType:QAVVIDEO_SRC_TYPE_CAMERA];
    BOOL isHostCameraOn = NO;
    
    for (ILiveRenderView *rv in avRVArray)
    {
        if ([rv isEqual:hostRV])
        {
            isHostCameraOn = YES;
        }
    }
    [self.floatView configLiveFloatView:self.liveItem isCameraOn:isHostCameraOn];
    
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
        TILLiveManager *manager = [TILLiveManager getInstance];
        [manager modifyAVRenderView:self.view.bounds forIdentifier:self.liveItem.info.host srcType:QAVVIDEO_SRC_TYPE_CAMERA];
    }];
}

@end
