//
//  BaseViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    [self bgImageView];
    [self headerView];
    [self contentView];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:kAppBgImageStr];
        [self.view addSubview:(_bgImageView = bgImageV)];
    }
    return _bgImageView;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight)];
        
        // 返回视图
        UIView *backView = [[UIView alloc] init];
        if (self.isExitLeftItem) {
            backView.frame = CGRectMake(kMarginView_horizontal, kDefaultStatuHeight, 60, kDefaultCellHeight);
            UIImageView *imageV = [WCUIKitControl createImageViewWithFrame:CGRectMake(0, 0, 20, kDefaultCellHeight) ImageName:@""];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, kDefaultCellHeight)];
            label.userInteractionEnabled = YES;
            label.attributedText = [CommonUtil customAttString:@"返回"
                                                      fontSize:kAppMiddleFontSize
                                                     textColor:WCWhite
                                                     charSpace:kAppKern_4
//                                                      fontName:kFontNameDroidSansFallback
                                    ];
            [backView addSubview:imageV];
            [backView addSubview:label];
            
            UITapGestureRecognizer *backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
            [backView addGestureRecognizer:backClick];
        }
        else
            backView.frame = CGRectMake(kMarginView_top, 0, 0, 0);
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
//                                                       fontName:kFontNameDroidSansFallback
                                     ];
        [headerView addSubview:titleLabel];
        
        [self.view addSubview:(_headerView = headerView)];
    }
    return _headerView;
}

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    UILabel *label = [self.headerView viewWithTag:110];
    label.attributedText = [CommonUtil customAttString:_headerTitle
                                              fontSize:kAppNaviFontSize
                                             textColor:WCWhite
                                             charSpace:kAppKern_2
//                                              fontName:kFontNameDroidSansFallback
                            ];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)contentView {
    if (!_contentView) {

        CGFloat baseHeight = 667 - kDefaultStatuHeight - kDefaultTabbarHeight;
        CGFloat deviceHeight = SCREENH_HEIGHT - kDefaultTabbarHeight - kDefaultStatuHeight;
        
        CGFloat contentX = 30.5 / 375 * SCREEN_WIDTH;
        CGFloat contentY =  4 / baseHeight * deviceHeight + kDefaultNaviHeight;
        CGRect cFrame = CGRectMake(contentX,
                                   contentY,
                                   SCREEN_WIDTH - 2 * contentX,
                                   SCREENH_HEIGHT - contentY - kDefaultTabbarHeight - 49 / baseHeight * deviceHeight);
        
        UIView *contentView = [[UIView alloc] initWithFrame:cFrame];
        
        WCViewBorder_Radius(contentView, kRadiusView);
        contentView.backgroundColor = WCBgColor;
        contentView.layer.shadowOffset = CGSizeMake(3, -5);
        contentView.layer.shadowColor = WCRed.CGColor;
        [self.view addSubview:(_contentView = contentView)];
    }
    return _contentView;
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
