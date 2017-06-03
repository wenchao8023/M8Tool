//
//  MeetingLuanchViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchViewController.h"
#import "MeetingLuanchTableView.h"

@interface MeetingLuanchViewController ()

@property (nonatomic, strong) MeetingLuanchTableView *tableView;

@end

@implementation MeetingLuanchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self configTabelViewArgu];
    
    
}



- (void)subView:(UIView *)view {
    WCLog(@"super class is <#%@#>, originY is <#%g#>, height is <#%g#>", NSStringFromClass([view class]), view.y, view.height);
    for (UIView *subView in [view subviews]) {
        if ([subView subviews]) {
            [self subView:subView];
        } else {
            WCLog(@"class is <#%@#>, originY is <#%g#>, height is <#%g#>", NSStringFromClass([subView class]), subView.y, subView.height);
        }
    }
    
}

- (void)createUI {
    // 重新设置 contentView 的高度
//    [self.contentView setHeight:kContentHeight_bottom30];
    // 添加 tableView
    [self tableView];
    // 添加 发起按钮
    [self luanchButton];
}

- (MeetingLuanchTableView *)tableView {
    if (!_tableView) {
        CGRect frame = self.contentView.bounds;
        frame.size.height -= (kDefaultMargin + kDefaultCellHeight);     // 减去 底部按钮所占的高度
        MeetingLuanchTableView *tableView = [[MeetingLuanchTableView alloc] initWithFrame:frame
                                                                                    style:UITableViewStyleGrouped];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

- (void)luanchButton {
    UIButton *luanchButton = [WCUIKitControl createButtonWithFrame:CGRectMake(kDefaultMargin,
                                                                              self.contentView.height - kDefaultMargin - kDefaultCellHeight,
                                                                              self.contentView.width - 2 * kDefaultMargin,
                                                                              kDefaultCellHeight)
                                                            Target:self
                                                            Action:@selector(luanchMeetingAction)
                                                             Title:@"立即发起"];
    [luanchButton setAttributedTitle:[CommonUtil customAttString:luanchButton.titleLabel.text
                                                        fontSize:kAppNaviFontSize
                                                       textColor:WCWhite
                                                       charSpace:kAppKern_2]
                            forState:UIControlStateNormal];
    WCViewBorder_Radius(luanchButton, kDefaultCellHeight / 2);
    [luanchButton setBackgroundColor:WCButtonColor];
    [self.contentView addSubview:luanchButton];
}

- (void)luanchMeetingAction {
    WCLog(@"立即发起<!--%@--!>", [[self getTitle] substringFromIndex:2]);
}

#pragma mark - 判断视图类型
- (NSString *)getTitle {
    switch (self.luanchMeetingType) {
        case LuanchMeetingType_phone:
            return @"创建电话会议";
            break;
        case LuanchMeetingType_video:
            return @"创建视频会议";
            break;
        case LuanchMeetingType_live:
            return @"创建云直播会议";
            break;
        case LuanchMeetingType_order:
            return @"会议预约";
        default:
            return @"会议";
            break;
    }
}

- (void)configTabelViewArgu {
    switch (self.luanchMeetingType) {
        case LuanchMeetingType_phone:
            self.tableView.isHiddenFooter = NO;
            self.tableView.MaxMembers = 5;
            break;
        case LuanchMeetingType_video:
            self.tableView.isHiddenFooter = NO;
            self.tableView.MaxMembers = 3;
            break;
        case LuanchMeetingType_live:
            self.tableView.isHiddenFooter = YES;
            self.tableView.MaxMembers = 0;
            break;
        case LuanchMeetingType_order:
            self.tableView.isHiddenFooter = NO;
            self.tableView.MaxMembers = 100;
            break;
        default:
            break;
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
