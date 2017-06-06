//
//  UserSettingViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserSettingTabelView.h"



#define kImageWidth     (SCREEN_WIDTH   * 280 / 375)
#define kImageHeight    (kImageWidth    * 200 / 280)



@interface UserSettingViewController ()

@property (nonatomic, strong) UserSettingTabelView *tableView;

@end

@implementation UserSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    // 重新设置 contentView 的高度
    [self.contentView setHeight:kContentHeight_setting];
    // 添加 tableView
    [self tableView];
    // 添加 contentView 下面的 三角
    // 添加 会议系统 图片
    [self drawViews];
    
}

- (void)drawViews {
    UILabel *triangleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(0, 0, 32, 32) BgColor:WCBgColor];
    [triangleLabel setCenterX:self.contentView.centerX];
    [triangleLabel setCenterY:CGRectGetMaxY(self.contentView.frame)];
    [triangleLabel setTransform:CGAffineTransformMakeRotation(M_PI_4)];
    [self.view insertSubview:triangleLabel belowSubview:self.contentView];
    
    CGFloat contentHeight = (SCREENH_HEIGHT - CGRectGetMaxY(triangleLabel.frame) - 60);
    
    
    UIImageView *imageV = [WCUIKitControl createImageViewWithFrame:CGRectMake(0, 0, kImageWidth, kImageHeight) ImageName:@"M6"];
    [imageV setCenterX:triangleLabel.centerX];
    [imageV setCenterY:CGRectGetMaxY(triangleLabel.frame) + contentHeight / 2];
    [self.view addSubview:imageV];
    
}


- (UserSettingTabelView *)tableView {
    if (!_tableView) {
        UserSettingTabelView *tableView = [[UserSettingTabelView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    return _tableView;
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
