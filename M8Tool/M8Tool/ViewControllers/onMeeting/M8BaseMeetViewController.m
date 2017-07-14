//
//  M8BaseMeetViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseMeetViewController.h"


@interface M8BaseMeetViewController ()

@property (nonatomic, strong) UIWindow *meetWindow;

@end



@implementation M8BaseMeetViewController




#pragma mark - inits
- (instancetype)initWithItem:(TCShowLiveListItem *)item isHost:(BOOL)isHost
{
    if (self = [super init])
    {
        _liveItem = item;
        _isHost = isHost;
    }
    return self;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView)
    {
        NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
        UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:imgStr ? imgStr : kDefaultThemeImage];
        [self.view addSubview:(_bgImageView = bgImageV)];
    }
    return _bgImageView;
}

- (UIButton *)exitButton
{
    if (!_exitButton)
    {
        UIButton *exitButton = [WCUIKitControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 44, 24, 44, 36) Target:self Action:@selector(selfDismiss) ImageName:@"onMeetExit"];
        exitButton.backgroundColor = WCClear;
        [self.view addSubview:(_exitButton = exitButton)];
    }
    return _exitButton;
}

- (M8BaseFloatView *)floatView
{
    if (!_floatView)
    {
        M8BaseFloatView *floatView = [[M8BaseFloatView alloc] initWithFrame:CGRectMake(0, 0, kFloatWindowWidth, kFloatWindowHeight)];
        floatView.contentMode = UIViewContentModeScaleAspectFill;
        floatView.WCDelegate = self;
        floatView.initOrientation = [UIApplication sharedApplication].statusBarOrientation;
        floatView.originTransform = floatView.transform;
        _floatView = floatView;
    }
    return _floatView;
}

- (UIWindow *)meetWindow
{
    if (!_meetWindow)
    {
        UIWindow *meetWindow = [[UIWindow alloc] init];
        meetWindow.frame = CGRectMake(SCREEN_WIDTH - kFloatWindowWidth, 70, kFloatWindowWidth, kFloatWindowHeight);
        meetWindow.windowLevel = UIWindowLevelAlert + 1;
        meetWindow.backgroundColor = [UIColor clearColor];
        [meetWindow makeKeyAndVisible];
        
        [meetWindow addSubview:self.floatView];
        
        _meetWindow = meetWindow;
    }
    return _meetWindow;
}




#pragma mark - views life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self setMeetingStatu];
    
    [self addSubViews];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view bringSubviewToFront:self.exitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- view did load
- (void)setMeetingStatu
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setBool:YES forKey:kIsInMeeting];
    [userD synchronize];
}

- (void)addSubViews
{
    [self bgImageView];
    [self exitButton];
    [self meetWindow];
}

- (void)addNotifications
{
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
    [WCNotificationCenter addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}




#pragma mark - link window
- (void)setRootView
{
    self.floatView.rootView = self.view.superview;
}


/**
 隐藏浮动窗口
 */
- (void)hiddeFloatView
{
    self.isInFloatView = NO;
    
    //将通话视图添加到视图的最上层
    UIView *superView = self.view.superview;
    [superView bringSubviewToFront:self.view];
}

/**
 显示浮动窗口
 */
- (void)showFloatView
{
    self.isInFloatView = YES;
}

- (void)M8FloatViewDidClick
{
    [self hiddeFloatView];
}




#pragma mark - actions
#pragma mark -- notify actions
- (void)orientationChange:(NSNotification *)notification
{
    [self.floatView floatViewRotate];
}

- (void)themeSwichAction
{
    NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
    [self.bgImageView setImage:[UIImage imageNamed:imgStr]];
}


#pragma mark -- self dismiss
- (void)selfDismiss
{
    //退出视图的时候需要将 菜单的推出状态记为NO
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:@(NO) forKey:kPushMenuStatus];
    [userD synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
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
        }];
    });
}



#pragma mark - live push
- (void)onLivePushStart
{
    ILivePushOption *option = [[ILivePushOption alloc] init];
    ILiveChannelInfo *info = [[ILiveChannelInfo alloc] init];
    info.channelName = @"测试频道";     //直播码模式下无意义
    info.channelDesc = @"测试频道描述";  //直播码模式下无意义
    option.channelInfo = info;
    option.encodeType = AV_ENCODE_HLS;
    option.recrodFileType = AV_RECORD_FILE_TYPE_HLS;
    
    [[ILiveRoomManager getInstance] startPushStream:option succ:^(id selfPtr) {
        AVStreamerResp *resp = (AVStreamerResp *)selfPtr;
        NSLog(@"推流成功 %@", [resp urls]);
        WCLog(@"=================================");
        for (AVLiveUrl *url in [resp urls])
        {
            WCLog(@"%@", [NSString stringWithFormat:@"推流地址是:\t%@", url.playUrl]);
        }
        WCLog(@"=================================");
        NSLog(@"推流获取到的频道ID：%llu", resp.channelID);
        self.pushID = resp.channelID;
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"推流失败");
    }];
}

- (void)onLivePushStop
{
    //  pushID为startPushStream中返回的频道ID
    NSArray *chids = @[@(self.pushID)];
    [[ILiveRoomManager getInstance] stopPushStreams:chids succ:^{
        NSLog(@"停止推流成功");
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"停止推流失败");
    }];
}



#pragma mark -- dealloc
- (void)dealloc
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setBool:NO forKey:kIsInMeeting];
    [userD synchronize];
    
    [WCNotificationCenter removeObserver:self name:kThemeSwich_Notification object:nil];
    [WCNotificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    WCLog(@"%@ has been dealloc", NSStringFromClass([self class]));
}

@end
