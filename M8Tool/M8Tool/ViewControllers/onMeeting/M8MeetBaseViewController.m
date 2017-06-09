//
//  M8MeetBaseViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetBaseViewController.h"

@interface M8MeetBaseViewController ()


@end

@implementation M8MeetBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    
    [self bgImageView];
    [self headerView];
    [self deviceView];
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
        UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:imgStr ? imgStr : kDefaultThemeImage];
        [self.view addSubview:(_bgImageView = bgImageV)];
    }
    return _bgImageView;
}

- (M8MeetHeaderView *)headerView {
    if (!_headerView) {
        M8MeetHeaderView *headerView = [[M8MeetHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        [self.view addSubview:(_headerView = headerView)];
    }
    return _headerView;
}


- (M8MeetDeviceView *)deviceView {
    if (!_deviceView) {
        M8MeetDeviceView *deviceView = [[M8MeetDeviceView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT - kBottomHeight - kDefaultMargin, SCREEN_WIDTH, kBottomHeight)];
        deviceView.WCDelegate = self;
        [self.view addSubview:(_deviceView = deviceView)];
    }
    return _deviceView;
}

- (void)themeSwichAction {
    NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
    [self.bgImageView setImage:[UIImage imageNamed:imgStr]];
}

- (void)dealloc {
    
    [WCNotificationCenter removeObserver:self name:kThemeSwich_Notification object:nil];
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
