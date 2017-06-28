//
//  M8LiveBaseViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveBaseViewController.h"

@interface M8LiveBaseViewController ()<FloatRenderViewDelegate>

@property (nonatomic, strong) UIWindow *meetWindow;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation M8LiveBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self createSuperUI];
    
    [self addNotifications];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加通知
- (void)addNotifications {
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
    [WCNotificationCenter addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - createSuperUI(这里命名不能和子类同名)
- (void)createSuperUI {
    
    [self bgImageView];
    
    [self backButton];
    
    [self livingPlayView];
    
    [self.meetWindow addSubview:self.floatView];
}

- (UIButton *)backButton {
    if (!_backButton) {
        UIButton *backButton = [WCUIKitControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 44, 24, 44, 36) Target:self Action:@selector(selfDismiss) ImageName:@""];
        backButton.backgroundColor = WCRed;
        [self.view addSubview:backButton];
        [self.view bringSubviewToFront:(_backButton = backButton)];
    }
    return _backButton;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
        UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:imgStr ? imgStr : kDefaultThemeImage];
        [self.view addSubview:(_bgImageView = bgImageV)];
    }
    return _bgImageView;
}

- (M8LiveInfoView *)livingInfoView {
    if (!_livingInfoView) {
        M8LiveInfoView *livingInfoView = [[M8LiveInfoView alloc] initWithFrame:self.view.bounds];
        [self.livingPlayView addSubview:(_livingInfoView = livingInfoView)];
    }
    return _livingInfoView;
}

- (M8LivePlayView *)livingPlayView {
    if (!_livingPlayView) {
        M8LivePlayView *livingPlayView = [[M8LivePlayView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:(_livingPlayView = livingPlayView) aboveSubview:self.bgImageView];
    }
    return _livingPlayView;
}


#pragma mark -- link window in super viewController
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
        
        //        [self._call modifyRenderView:curFrame forIdentifier:self.currentIdentify];
    }
}

/**
 显示浮动窗口
 */
- (void)showFloatView {
    
    _isFloatView = YES;
    
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
    
    // 1. 隐藏浮动窗口
    self.floatView.hidden = YES;
    // 2. 将通话界面从底部移动到手机视图
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        // 3. 应该要通知 通话界面 重新刷新位置
        //        [self.renderView updateRenderCollection];
    }];
}


#pragma mark - actions
//- (void)addTextToView:(NSString *)newText {
//    
//}

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
    
    WCLog(@"live base view controller has been dealloc");
}


@end
