//
//  M8CallBaseViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallBaseViewController.h"




#define kFloatViewWidth     (SCREEN_WIDTH - 50) / 4
#define kFloatViewHeight    kFloatViewWidth * 4 / 3


@interface M8CallBaseViewController ()<FloatRenderViewDelegate>

@property (nonatomic, copy) NSString *currentIdentify;

@property (nonatomic, strong) UIWindow *meetWindow;

@end

@implementation M8CallBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, SCREENH_HEIGHT);
    
    [self createUI];
    
    [self.meetWindow addSubview:self.floatView];
    
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
    [WCNotificationCenter addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - link window in super viewController
- (M8FloatRenderView *)floatView {
    if (!_floatView) {
        M8FloatRenderView *floatView = [[M8FloatRenderView alloc] init];
        floatView.contentMode = UIViewContentModeScaleAspectFill;
        floatView.frame = CGRectMake(0, 0, kFloatViewWidth, kFloatViewHeight);
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
        meetWindow.frame = CGRectMake(SCREEN_WIDTH - kFloatViewWidth, 70, kFloatViewWidth, kFloatViewHeight);
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

- (void)showFloatView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        self.floatView.hidden = NO;
    }];
}

- (void)hiddeFloatView {
    self.floatView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
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
        M8CallRenderView *renderView = [[M8CallRenderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
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
        M8CallVideoDevice *deviceView = [[M8CallVideoDevice alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT - kBottomHeight - kDefaultMargin, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        [self.view addSubview:(_deviceView = deviceView)];
    }
    return _deviceView;
}

- (M8CallAudioDevice *)audioDeviceView {
    if (!_audioDeviceView) {
        M8CallAudioDevice *audioDeviceView = [[M8CallAudioDevice alloc] initWithFrame:CGRectMake(0,
                                                                                                 SCREENH_HEIGHT - kBottomHeight - kDefaultMargin,
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
    NSString *infoValue = [actionInfo objectForKey:infoKey];
    if ([infoKey isEqualToString:kHeaderAction]) {
        [self showFloatView];
    }
    
    if ([infoKey isEqualToString:kCallValue_id]) {
        self.currentIdentify = infoValue;
    }
    
    
}


#pragma mark -- MeetDeviceDelegate
- (void)MeetDeviceActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
}

#pragma mark -- CallRenderDelegate
- (void)CallRenderActionInfo:(NSDictionary *)actionInfo {
    
    [self addTextToView:[actionInfo allValues][0]];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

/**
 zoom render view to presentingVC
 */
- (void)zoomRenderView {

    UIViewController *presentTabbar = [self presentingViewController];  //MainTabBarController
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [M8FloatWindow M8_addWindowOnTarget:presentTabbar onClick:nil];
//        
//        [M8FloatWindow M8_setRenderViewCall:self._call identify:self.currentIdentify];
//    }];
    
//    if ([presentTabbar isKindOfClass:[UITabBarController class]])
//    {
//        UIViewController *selectVc = [((UITabBarController *)presentTabbar) selectedViewController]; // UINavigationController
//        if ([selectVc  isKindOfClass:[UINavigationController class]])
//        {
//            UIViewController *presentingTopVC = [((UINavigationController *)selectVc) topViewController]; //really presenting view controller
//            
//            
//            [self dismissViewControllerAnimated:YES completion:^{
//                [M8FloatWindow M8_addWindowOnTarget:presentingTopVC onClick:^{
//                    
//                }];
//                
//                [M8FloatWindow M8_setRenderViewCall:self._call identify:self.currentIdentify];
//            }];
//        }
//    }
}

#pragma mark - private actions
- (void)themeSwichAction {
    NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
    [self.bgImageView setImage:[UIImage imageNamed:imgStr]];
}

- (void)dealloc {
    
    [WCNotificationCenter removeObserver:self name:kThemeSwich_Notification object:nil];
    
    WCLog(@"call base view controller has been dealloc");
}




@end
