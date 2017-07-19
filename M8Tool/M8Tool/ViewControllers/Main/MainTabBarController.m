//
//  MainTabBarController.m
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MainTabBarController.h"

#import "M8MeetRecordViewController.h"
#import "MeetingViewController.h"
#import "UserViewController.h"

#import "M8CallComingListener.h"


@interface MainTabBarController ()<UITabBarControllerDelegate>
{
    UIButton *_meetingButton;
}

@end

@implementation MainTabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WCLog(@"tabbar view controller will appear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置来电监听
    [[TILCallManager sharedInstance] setIncomingCallListener:[[M8CallComingListener alloc] init]];
    
    [self initTabbar];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if(_meetingButton.superview != nil)
    {
        [_meetingButton removeFromSuperview];
    }
    [self.tabBar addSubview:_meetingButton];
}

- (void)initTabbar {
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:WCBgColor size:self.tabBar.frame.size]];

    
    self.delegate = self;
    
    M8MeetRecordViewController *recordVC  = [[M8MeetRecordViewController alloc] init];
    recordVC.listViewType               = M8MeetListViewTypeRecord;
    UINavigationController *recordNav   = [[UINavigationController alloc] initWithRootViewController:recordVC];
    
    MeetingViewController *meetingVC    = [[MeetingViewController alloc] init];
    UINavigationController *meetingNav  = [[UINavigationController alloc] initWithRootViewController:meetingVC];
    
    UserViewController *UserVC    = [[UserViewController alloc] init];
    UINavigationController *UserNav  = [[UINavigationController alloc] initWithRootViewController:UserVC];
    
    self.viewControllers = [NSArray arrayWithObjects:recordNav, meetingNav, UserNav, nil];
    
    
    UITabBarItem *recordItem    = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *meetingItem   = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *UserItem      = [self.tabBar.items objectAtIndex:2];
    

    [self setTabBarItem:recordItem  withNormalImageName:@"tabbarHistory" andSelectedImageName:@"tabbarHistory_hover" andTitle:@"会议记录"];
    [self setTabBarItem:meetingItem withNormalImageName:@"" andSelectedImageName:@""  andTitle:@""];
    [self setTabBarItem:UserItem withNormalImageName:@"tabbarContact" andSelectedImageName:@"tabbarContact_hover" andTitle:@"我的"];
    
    
    // 会议中心
    _meetingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _meetingButton.frame = CGRectMake(self.tabBar.frame.size.width/2-30, -15, 60, 60);

    
    [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter"] forState:UIControlStateNormal];
    
    
    _meetingButton.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
    [_meetingButton addTarget:self action:@selector(onLiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self onLiveButtonClicked];
}



- (void)setTabBarItem:(UITabBarItem *) tabBarItem withNormalImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andTitle:(NSString *)title
{
    // 添加原始图片
    [tabBarItem setImage:[[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem setTitle:title];
    [tabBarItem setTitleTextAttributes:[CommonUtil customAttsWithFontSize:0
                                                                textColor:WCTabbarNormalColor
                                                                charSpace:kAppKern_2
                                                                 fontName:kFontNameDroidSansFallback]
                              forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:[CommonUtil customAttsWithFontSize:0
                                                                textColor:WCTabbarSelectedColor
                                                                charSpace:kAppKern_2
                                                                 fontName:kFontNameDroidSansFallback]
                              forState:UIControlStateSelected];
    
}


- (void)onLiveButtonClicked
{
    if (self.selectedIndex == 1) {
        [self popToNaviTootViewController];
    }
    else {
        self.selectedIndex = 1;
        [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter_hover"] forState:UIControlStateNormal];
    }
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    if (tabBarController.selectedIndex == 1) {
        [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter_hover"] forState:UIControlStateNormal];
    }
    else {
        [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter"] forState:UIControlStateNormal];
    }
}


/**
 回到导航控制器的根视图
 */
- (void)popToNaviTootViewController {
    UINavigationController *navi = self.viewControllers[self.selectedIndex];
    if (navi.viewControllers.count &&
        navi.viewControllers.count > 1) {   //存在多个 viewController
        [navi popToRootViewControllerAnimated:YES];
    }
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
