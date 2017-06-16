//
//  M8FloatWindowController.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatWindowController.h"
#import "M8FloatRenderView.h"
#import "M8FloatWindowSingleton.h"


#define kFloatWindowWidth    (SCREEN_WIDTH - 50) / 4
#define kFloatWindowHeight   kFloatWindowWidth * 4 / 3

@interface M8FloatWindowController ()<FloatRenderViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) M8FloatRenderView *renderView;



@end

@implementation M8FloatWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // hide the root view
    self.view.frame = CGRectZero;
    // create floating window renderView
    [self createRenderView];
    // register UIDeviceOrientationDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)createRenderView {
    // 1. floating render view
    M8FloatRenderView *renderView = [[M8FloatRenderView alloc] init];
    renderView.contentMode = UIViewContentModeScaleAspectFill;
    renderView.frame = CGRectMake(0, 0, kFloatWindowWidth, kFloatWindowHeight);
    renderView.WCDelegate = self;
    renderView.initOrientation = [UIApplication sharedApplication].statusBarOrientation;
    renderView.originTransform = renderView.transform;
    
    // 2. floating window default in left boarder
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kFloatWindowWidth, 70, kFloatWindowWidth, kFloatWindowHeight)];
    window.windowLevel = UIWindowLevelAlert + 1;
    window.backgroundColor = [UIColor clearColor];
    [window addSubview:renderView];
    [window makeKeyAndVisible];
    
    _renderView = renderView;
    _window     = window;
}

- (void)setRenderViewCall:(TILMultiCall *)call identify:(NSString *)identify {
    [call createRenderViewIn:self.renderView];
    
    [call modifyRenderView:self.renderView.bounds forIdentifier:identify];
}


/**
 set rootView for renderView
 */
- (void)setRootView {
    _renderView.rootView = self.view.superview;
}

- (void)floatRenderViewDidClicked {
    NSLog(@"render view did be clicked");
    
    
}

//- (void)setWindowHide:(BOOL)hide {
//    _window.hidden = hide;
//}

//- (void)setWindowSize:(CGSize)size {
//    CGRect frame = _window.frame;
//    _window.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
//    _window.frame = CGRectMake(0, 0, size.width, size.height);
//    [self.view setNeedsLayout];
//}


- (void)orientationChange:(NSNotification *)notification {
    [_renderView floatViewRotate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
