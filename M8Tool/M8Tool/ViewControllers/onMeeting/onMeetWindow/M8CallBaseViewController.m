//
//  M8CallBaseViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallBaseViewController.h"

#import "UserContactViewController.h"


@interface M8CallBaseViewController ()<FloatRenderViewDelegate>

@property (nonatomic, copy) NSString *currentIdentify;

@property (nonatomic, strong) UIWindow *meetWindow;

@end

@implementation M8CallBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self createUI];
    
    [self.meetWindow addSubview:self.floatView];
    
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
    [WCNotificationCenter addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    WCLog(@"Call base frame is : %@", NSStringFromCGRect(self.view.frame));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - link window in super viewController
- (M8FloatRenderView *)floatView {
    if (!_floatView) {
        M8FloatRenderView *floatView = [[M8FloatRenderView alloc] initWithFrame:CGRectMake(0, 0, kFloatWindowWidth, kFloatWindowHeight)];
        floatView.contentMode = UIViewContentModeScaleAspectFill;
        floatView.WCDelegate = self;
        floatView.initOrientation = [UIApplication sharedApplication].statusBarOrientation;
        floatView.originTransform = floatView.transform;
        _floatView = floatView;
    }
    return _floatView;
}

- (UIWindow *)meetWindow {
    if (!_meetWindow) {
        UIWindow *meetWindow = [[UIWindow alloc] init];
        meetWindow.frame = CGRectMake(SCREEN_WIDTH - kFloatWindowWidth, 70, kFloatWindowWidth, kFloatWindowHeight);
        meetWindow.windowLevel = UIWindowLevelAlert + 1;
        meetWindow.backgroundColor = [UIColor clearColor];
        [meetWindow makeKeyAndVisible];
        _meetWindow = meetWindow;
    }
    return _meetWindow;
}

- (void)setRootView {
    self.floatView.rootView = self.view.superview;
}

- (void)orientationChange:(NSNotification *)notification {
    [self.floatView floatViewRotate];
}

- (void)floatRenderViewDidClicked {
    
    [self hiddeFloatView];
}

- (void)floatRenderViewCenter:(CGPoint)center {
    [self modifyRenderViewWithFloatViewCenter:center];
}
// 重新计算  视频窗口的位置  保证是和浮动窗口一致
- (void)modifyRenderViewWithFloatViewCenter:(CGPoint)center {
    
    if (_isFloatView) {
        CGRect curFrame = CGRectMake(0, 0, kFloatWindowWidth, kFloatWindowHeight);
        curFrame.origin.x = center.x - kFloatWindowWidth / 2;
        curFrame.origin.y = center.y - kFloatWindowHeight / 2 - SCREEN_HEIGHT;
        
        [self._call modifyRenderView:curFrame forIdentifier:self.currentIdentify];
    }
}

/**
 显示浮动窗口
 */
- (void)showFloatView {
    
    _isFloatView = YES;
    [self.renderView setIsFloatView:YES];
    // 1. 将通话界面移动到视图底部，移出手机界面
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        // 2. 显示浮动窗口
        self.floatView.hidden = NO;
        // 3. 重新设置视频流位置
        [self modifyRenderViewWithFloatViewCenter:self.meetWindow.center];
    }];
}

/**
 隐藏浮动窗口
 */
- (void)hiddeFloatView {
    
    [self.renderView setIsFloatView:NO];
    // 1. 隐藏浮动窗口
    self.floatView.hidden = YES;
    // 2. 将通话界面从底部移动到手机视图
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        // 3. 应该要通知 通话界面 重新刷新位置
        [self.renderView updateRenderCollection];
    }];
}

#pragma mark - createUI
- (void)createUI {
    
    [self bgImageView];
    [self renderView];
    [self headerView];
    [self deviceView];
    [self audioDeviceView];
}


- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
        UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:imgStr ? imgStr : kDefaultThemeImage];
        [self.view addSubview:(_bgImageView = bgImageV)];
    }
    return _bgImageView;
}

- (M8CallRenderView *)renderView {
    if (!_renderView) {
        M8CallRenderView *renderView = [[M8CallRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        renderView.WCDelegate = self;
        [self.view addSubview:(_renderView = renderView)];
    }
    return _renderView;
}


- (M8CallHeaderView *)headerView {
    if (!_headerView) {
        M8CallHeaderView *headerView = [[M8CallHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        headerView.WCDelegate = self;
        [self.view addSubview:(_headerView = headerView)];
    }
    return _headerView;
}


- (M8CallVideoDevice *)deviceView {
    if (!_deviceView) {
        M8CallVideoDevice *deviceView = [[M8CallVideoDevice alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight - kDefaultMargin, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        [self.view addSubview:(_deviceView = deviceView)];
    }
    return _deviceView;
}

- (M8CallAudioDevice *)audioDeviceView {
    if (!_audioDeviceView) {
        M8CallAudioDevice *audioDeviceView = [[M8CallAudioDevice alloc] initWithFrame:CGRectMake(0,
                                                                                                 SCREEN_HEIGHT - kBottomHeight - kDefaultMargin,
                                                                                                 SCREEN_WIDTH,
                                                                                                 kBottomHeight)
                                              ];
        audioDeviceView.WCDelegate = self;
        [self.view addSubview:(_audioDeviceView = audioDeviceView)];
    }
    return _audioDeviceView;
}


#pragma mark - views delegate
#pragma mark -- MeetHeaderDelegate
- (void)MeetHeaderActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
//    NSString *infoValue = [actionInfo objectForKey:infoKey];
    if ([infoKey isEqualToString:kHeaderAction]) {
        [self showFloatView];
    }
}


#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
}

#pragma mark -- CallRenderDelegate
- (void)CallRenderActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
    
    NSString *infoKey = [[actionInfo allKeys] firstObject];
    
    if ([infoKey isEqualToString:kCallValue_model]) {   // value : @{identify : model}
        NSDictionary *valueDic = [actionInfo objectForKey:infoKey];
        NSString *valueKey = [valueDic allKeys][0];
        self.currentIdentify = valueKey;
        
        // config float view with model
        [self.floatView configWithRenderModel:[valueDic objectForKey:valueKey]];
    }
    
    if ([infoKey isEqualToString:kCallAction]) {
        NSString *infoValue = [actionInfo objectForKey:infoKey];
        if ([infoValue isEqualToString:@"inviteAction"]) {
            UserContactViewController *contactVC = [[UserContactViewController alloc] init];
            contactVC.isExitLeftItem = YES;
            contactVC.contactType = ContactType_sel;
            [self.navigationController pushViewController:contactVC animated:YES];
        }
    }
}

#pragma mark -- CallAudioDeviceDelegate
- (void)CallAudioDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
}


#pragma mark - actions
- (void)addTextToView:(NSString *)newText {
    [self.renderView addTextToView:newText];
}

- (void)selfDismiss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // 1. 将 通话界面 移到视图底部，（造成退出界面的动画）
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            // 2. 将 self 移除父视图
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            // 3. 将 属性 置为空
            self.floatView = nil;
            self.meetWindow = nil;
        }];
    });
}

#pragma mark - private actions
- (void)themeSwichAction {
    NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
    [self.bgImageView setImage:[UIImage imageNamed:imgStr]];
}

- (void)dealloc {
    
    [WCNotificationCenter removeObserver:self name:kThemeSwich_Notification object:nil];
    [WCNotificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    WCLog(@"call base view controller has been dealloc");
}




@end
