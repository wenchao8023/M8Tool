//
//  MeetingLuanchViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchViewController.h"
#import "MeetingLuanchTableView.h"

#import "M8LiveMeetViewController.h"



@interface MeetingLuanchViewController ()<LuanchTableViewDelegate>

@property (nonatomic, strong) MeetingLuanchTableView *tableView;
    
@property (nonatomic, strong) NSString *topic;

@end

@implementation MeetingLuanchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.WCDelegate = self;
    
    [self createUI];
    
    [self configTabelViewArgu];
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
    
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoStatus == AVAuthorizationStatusRestricted || videoStatus == AVAuthorizationStatusDenied)
    {
        [AppDelegate showAlert:self title:nil message:@"您没有相机使用权限,请到 设置->隐私->相机 中开启权限" okTitle:@"确定" cancelTitle:nil ok:nil cancel:nil];
        return;
    }
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioStatus == AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied)
    {
        [AppDelegate showAlert:self title:nil message:@"您没有麦克风使用权限,请到 设置->隐私->麦克风 中开启权限" okTitle:@"确定" cancelTitle:nil ok:nil cancel:nil];
        return;
    }
    
    if (!(self.topic && self.topic.length > 0))
    {
        [AppDelegate showAlert:self title:nil message:@"请输入直播标题" okTitle:@"确定" cancelTitle:nil ok:nil cancel:nil];
        return;
    }
    
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在请求房间ID"];
    [self.view addSubview:reqIdWaitView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [reqIdWaitView removeFromSuperview];
    });
    
    [self luanchMeeting];
}

    
/**
 发起会议
 */
- (void)luanchMeeting {
    
    NSString *roomId = [self getRoomID];    //应该要从服务端获取
    
    switch (self.luanchMeetingType) {
        case LuanchMeetingType_phone:   //电话(语音)
        
        break;
        case LuanchMeetingType_video:   //视频
        
        break;
        case LuanchMeetingType_live:    //直播
        {
            M8LiveMeetViewController *liveVC = [[M8LiveMeetViewController alloc] init];
            liveVC.roomId = [roomId integerValue];
            liveVC.topic  = self.topic;
            [[AppDelegate sharedAppDelegate] presentViewController:liveVC];
        }
        break;
        case LuanchMeetingType_order:   //预订
        
        default:
        
        break;
    }
}


- (NSString *)getRoomID {
    
    return [NSString stringWithFormat:@"9876%0d", arc4random_uniform(100)];
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

    
#pragma mark - LuanchTableViewDelegate
- (void)luanchTableViewMeetingTopic:(NSString *)topic {
    self.topic = topic;
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
