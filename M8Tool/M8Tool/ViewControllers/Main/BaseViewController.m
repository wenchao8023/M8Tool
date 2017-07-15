//
//  BaseViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIView *_bottomTipView;
}

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    BOOL isMeeting = [[[NSUserDefaults standardUserDefaults] objectForKey:kIsInMeeting] boolValue];

    BOOL isMeeting = [M8UserDefault getIsInMeeting];
    
    UINavigationController *curNavi = [[AppDelegate sharedAppDelegate] navigationViewController];
    
    if (isMeeting &&
        curNavi.viewControllers.count > 1)
    {
        _bottomTipView = [WCUIKitControl createViewWithFrame:CGRectMake(0, SCREEN_HEIGHT - kDefaultCellHeight, SCREEN_WIDTH, kDefaultCellHeight) BgColor:WCRed];
        UILabel *tipLabel = [WCUIKitControl createLabelWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, 10, 100, 20)
                                                            Text:@"会议中..."
                                                       TextColor:WCWhite
                                                         BgColor:WCClear];
        tipLabel.textAlignment = 1;
        
        [_bottomTipView addSubview:tipLabel];
        [self.view addSubview:_bottomTipView];
    }
    else
    {
        if (_bottomTipView)
        {
            [_bottomTipView removeFromSuperview];
            _bottomTipView = nil;
        }
    }
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    [self bgImageView];
    [self headerView];
    [self contentView];
    
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
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

- (UIView *)headerView
{
    if (!_headerView)
    {
        UIView *headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        
        // 返回视图
        UIView *backView = [[UIView alloc] init];
        if (self.isExitLeftItem) {
            backView.frame = CGRectMake(kContentOriginX, kDefaultStatuHeight, 60, kDefaultCellHeight);
            UIImageView *imageV = [WCUIKitControl createImageViewWithFrame:CGRectMake(0, 14, 8, 16) ImageName:@"naviBackIcon"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 40, kDefaultCellHeight)];
            label.userInteractionEnabled = YES;
            label.attributedText = [CommonUtil customAttString:@"返回"
                                                      fontSize:kAppMiddleFontSize
                                                     textColor:WCWhite
                                                     charSpace:kAppKern_2
                                    ];
            [backView addSubview:imageV];
            [backView addSubview:label];
            
            UITapGestureRecognizer *backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
            [backView addGestureRecognizer:backClick];
        }
        else
            backView.frame = CGRectMake(kContentOriginX, 0, 0, 0);
        [headerView addSubview:backView];
        
        // 标题
        CGFloat titleX = CGRectGetMaxX(backView.frame) + kMarginView_top;
        CGFloat titleW = SCREEN_WIDTH - 2 * titleX;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, kDefaultStatuHeight, titleW, kDefaultCellHeight)];
        titleLabel.textAlignment = 1;
        titleLabel.tag = 110;
        titleLabel.attributedText = [CommonUtil customAttString:self.headerTitle
                                                       fontSize:kAppNaviFontSize
                                                      textColor:WCWhite
                                                      charSpace:kAppKern_2
                                     ];
        [headerView addSubview:titleLabel];
        
        //右侧按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - kContentOriginX,
                                  kDefaultStatuHeight,
                                  60,
                                  kDefaultCellHeight);
        rightBtn.tag = 111;
        rightBtn.hidden = YES;
        [headerView addSubview:rightBtn];
        
    
        
        [self.view addSubview:(_headerView = headerView)];
    }
    return _headerView;
}



- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    UILabel *label = [self.headerView viewWithTag:110];
    label.attributedText = [CommonUtil customAttString:headerTitle
                                              fontSize:kAppNaviFontSize
                                             textColor:WCWhite
                                             charSpace:kAppKern_2
                            ];
}

// 文字按钮
- (void)setRightButtonTitle:(NSString *)title target:(id)target action:(SEL)action
{
    [self setRightButtonTitle:title image:nil target:target action:action];
}
// 图片按钮
- (void)setRightButtonImage:(NSString *)imgStr target:(id)target action:(SEL)action
{
    [self setRightButtonTitle:nil image:imgStr target:target action:action];
}

- (void)setRightButtonTitle:(NSString *)title image:(NSString *)imgStr target:(id)target action:(SEL)action
{
    UIButton *rightBtn = [self.headerView viewWithTag:111];
    rightBtn.hidden = NO;
    
    if (title)
    {
        [rightBtn setAttributedTitle:[CommonUtil customAttString:title
                                                        fontSize:kAppMiddleFontSize
                                                       textColor:WCWhite
                                                       charSpace:kAppKern_2]
                            forState:UIControlStateNormal];
    }
    
    if (imgStr)
    {
        [rightBtn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)contentView
{
    if (!_contentView)
    {
//        CGFloat baseHeight = 667 - kDefaultStatuHeight - kDefaultTabbarHeight;
//        CGFloat deviceHeight = SCREEN_HEIGHT - kDefaultTabbarHeight - kDefaultStatuHeight;
//        
//        CGFloat contentX = kContentOriginX;
//        CGFloat contentY =  4 / baseHeight * deviceHeight + kDefaultNaviHeight;
//        CGRect cFrame = CGRectMake(contentX,
//                                   contentY,
//                                   SCREEN_WIDTH - 2 * contentX,
//                                   SCREEN_HEIGHT - contentY - kDefaultTabbarHeight - 49 / baseHeight * deviceHeight);
        
        // 将宽度缩窄一点，对应的高度会增加一点
        CGFloat baseHeight = 667 - kDefaultStatuHeight - kDefaultTabbarHeight;
        CGFloat deviceHeight = SCREEN_HEIGHT - kDefaultTabbarHeight - kDefaultStatuHeight;
        
        CGFloat contentX = kContentOriginX - kDefaultMargin;
        CGFloat contentY =  4 / baseHeight * deviceHeight + kDefaultNaviHeight;
        CGFloat contentWidth    = SCREEN_WIDTH - 2 * contentX;
        CGFloat contentHeight   = SCREEN_HEIGHT - contentY - kDefaultTabbarHeight - 30 / baseHeight * deviceHeight;
        
        CGRect cFrame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
        
        UIView *contentView = [[UIView alloc] initWithFrame:cFrame];
        
        WCViewBorder_Radius(contentView, kRadiusView);
        contentView.backgroundColor = WCBgColor;
        contentView.layer.shadowOffset = CGSizeMake(3, -5);
        contentView.layer.shadowColor = WCRed.CGColor;
        [self.view addSubview:(_contentView = contentView)];
    }
    return _contentView;
}

- (void)themeSwichAction
{
    NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
    [self.bgImageView setImage:[UIImage imageNamed:imgStr]];
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kThemeSwich_Notification object:nil];
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
