//
//  MainTabBarController.m
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MainTabBarController.h"

#import "LoginManager.h"

#import "RecordViewController.h"
#import "MeetingViewController.h"
#import "UserViewController.h"



@interface MainTabBarController ()<UITabBarControllerDelegate>
{
    UIButton *_meetingButton;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self autoLogin];
    
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
    
    RecordViewController *recordVC      = [[RecordViewController alloc] init];
    recordVC.recordViewType             = RecordViewType_record;
    UINavigationController *recordNav   = [[UINavigationController alloc] initWithRootViewController:recordVC];
    
    MeetingViewController *meetingVC    = [[MeetingViewController alloc] init];
    UINavigationController *meetingNav  = [[UINavigationController alloc] initWithRootViewController:meetingVC];
    
    UserViewController *UserVC    = [[UserViewController alloc] init];
    UINavigationController *UserNav  = [[UINavigationController alloc] initWithRootViewController:UserVC];
    
    self.viewControllers = [NSArray arrayWithObjects:recordNav, meetingNav, UserNav, nil];
    
    
    UITabBarItem *recordItem    = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *meetingItem   = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *UserItem      = [self.tabBar.items objectAtIndex:2];
    
//    [self setTabBarItem:recordItem  withNormalImageName:@"video" andSelectedImageName:@"video_hover" andTitle:@"记录"];
//    [self setTabBarItem:meetingItem withNormalImageName:@"" andSelectedImageName:@""  andTitle:@""];
//    [self setTabBarItem:UserItem withNormalImageName:@"User" andSelectedImageName:@"User_hover" andTitle:@"我的"];
    [self setTabBarItem:recordItem  withNormalImageName:@"tabbarHistory" andSelectedImageName:@"tabbarHistory_hover" andTitle:@"会议记录"];
    [self setTabBarItem:meetingItem withNormalImageName:@"" andSelectedImageName:@""  andTitle:@""];
    [self setTabBarItem:UserItem withNormalImageName:@"tabbarContact" andSelectedImageName:@"tabbarContact_hover" andTitle:@"我的"];
    
    
    // 会议中心
    _meetingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _meetingButton.frame = CGRectMake(self.tabBar.frame.size.width/2-30, -15, 60, 60);
//    _meetingButton.layer.cornerRadius = 30;
//    _meetingButton.layer.borderWidth = 5;
//    _meetingButton.layer.borderColor = WCWhite.CGColor;
//    _meetingButton.layer.masksToBounds = YES;
    
    [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter"] forState:UIControlStateNormal];
    
    
    _meetingButton.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
    [_meetingButton addTarget:self action:@selector(onLiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}




- (void)setTabBarItem:(UITabBarItem *) tabBarItem withNormalImageName:(NSString *)normalImageName andSelectedImageName:(NSString *)selectedImageName andTitle:(NSString *)title
{
//    CGSize imgSize = CGSizeMake(30, 30);

    // 添加根据 size 裁剪的图片
//    [tabBarItem setImage:[[UIImage imageWithImage:[UIImage imageNamed:normalImageName] convertToSize:imgSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem setSelectedImage:[[UIImage imageWithImage:[UIImage imageNamed:selectedImageName] convertToSize:imgSize] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
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
    [self popToNaviTootViewController];
    self.selectedIndex = 1;
    [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter_hover"] forState:UIControlStateNormal];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    [self popToNaviTootViewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex != 1) {
        [_meetingButton setImage:[UIImage imageNamed:@"tabbarCenter"] forState:UIControlStateNormal];
    }
}

- (void)popToNaviTootViewController {
    UINavigationController *navi = self.viewControllers[self.selectedIndex];
    if (navi.viewControllers.count &&
        navi.viewControllers.count > 1) {   //存在多个 viewController
        [navi popToRootViewControllerAnimated:NO];
    }
}





- (void)autoLogin {
    LoginManager *manager = [LoginManager new];
    manager.loginTypeBlock = ^(LoginType type){
        switch (type) {
            case LoginType_Succ:
            {
                
            }
                break;
            case LoginType_Fail:
            {
                
            }
                break;
            case LoginType_Busy:
            {
                
            }
                break;
                
            default:
                break;
        }
    };
    [manager autoLogin];
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
