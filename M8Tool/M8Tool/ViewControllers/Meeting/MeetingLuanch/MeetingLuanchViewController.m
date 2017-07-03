//
//  MeetingLuanchViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchViewController.h"
#import "MeetingLuanchTableView.h"

#import "M8MeetWindow.h"
#import "M8MakeCallViewController.h"
#import "M8LiveMakeViewController.h"
#import "M8LiveJoinViewController.h"

#import "M8UploadImageHelper.h"



@interface MeetingLuanchViewController ()<LuanchTableViewDelegate>
{
    UIImage *_coverImg;
    NSString *_topic;
}

@property (nonatomic, strong) MeetingLuanchTableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectedArray;

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
        tableView.WCDelegate = self;
        [self.contentView addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
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
        [AlertHelp alertWith:nil message:@"您没有相机使用权限,请到 设置->隐私->相机 中开启权限" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioStatus == AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied)
    {
        [AlertHelp alertWith:nil message:@"您没有麦克风使用权限,请到 设置->隐私->麦克风 中开启权限" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    
    if (!(_topic && _topic.length > 0))
    {
        [AlertHelp alertWith:nil message:@"请输入直播标题" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return;
    }
    
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在请求房间ID"];
    [self.view addSubview:reqIdWaitView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [reqIdWaitView removeFromSuperview];
        
        [self luanchMeeting];
    });
}

    
/**
 发起会议
 */
- (void)luanchMeeting {
    
    switch (self.luanchMeetingType) {
        case LuanchMeetingType_phone:   //电话(语音)
        {
            [self luanchCall:TILCALL_TYPE_AUDIO];
        }
        break;
        case LuanchMeetingType_video:   //视频
        {
            [self luanchCall:TILCALL_TYPE_VIDEO];
        }
        break;
        case LuanchMeetingType_live:    //直播
        {
            [self luanchLiving];
        }
        break;
        case LuanchMeetingType_order:   //预订
        
        default:
        
        break;
    }
}


/**
 发起音视频会议

 @param callType 会议类型
 */
- (void)luanchCall:(TILCallType)callType {
    
    int roomId = [[AppDelegate sharedAppDelegate] getRoomID];
    
    M8MakeCallViewController *callVC = [[M8MakeCallViewController alloc] init];
    callVC.membersArray = self.selectedArray;
    callVC.callId       = roomId;
    callVC.callType     = callType;
    callVC.topic        = _topic;
    [M8MeetWindow M8_addCallSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
}


/**
 发起直播会议
 */
- (void)luanchLiving {
//  M8LiveJoinViewController *liveVC = [[M8LiveJoinViewController alloc] init];
    
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在请求房间ID"];
    [self.view addSubview:reqIdWaitView];
    __block CreateRoomResponceData *roomData = nil;
    __block NSString *imageUrl = nil;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        // 请求房间号
        CreateRoomRequest *createRoomReq = [[CreateRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
            roomData = (CreateRoomResponceData *)request.response.data;
            dispatch_semaphore_signal(semaphore);
            
        } failHandler:^(BaseRequest *request) {
            dispatch_semaphore_signal(semaphore);
        }];
        createRoomReq.token = [AppDelegate sharedAppDelegate].token;
        createRoomReq.type = @"live";
        [[WebServiceEngine sharedEngine] asyncRequest:createRoomReq];
        
        
        [[M8UploadImageHelper shareInstance] upload:_coverImg completion:^(NSString *imageSaveUrl) {
            imageUrl = imageSaveUrl;
            dispatch_semaphore_signal(semaphore);
            
        } failed:^(NSString *failTip) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC));
        dispatch_semaphore_wait(semaphore, timeoutTime);
        dispatch_semaphore_wait(semaphore, timeoutTime);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [reqIdWaitView removeFromSuperview];
            [self enterLive:(int)roomData.roomnum groupId:roomData.groupid imageUrl:imageUrl];
        });
    });
}

- (void)enterLive:(int)roomId groupId:(NSString *)groupid imageUrl:(NSString *)coverUrl
{
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid = [[ILiveLoginManager getInstance] getLoginId];
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title = _topic;
    item.info.type = @"live";
    item.info.roomnum = roomId;
    item.info.groupid = groupid;
    item.info.cover = coverUrl ? coverUrl : @"";
    item.info.appid = [ShowAppId intValue];
    item.info.host = [[ILiveLoginManager getInstance] getLoginId];
    
    M8LiveMakeViewController *liveVC = [[M8LiveMakeViewController alloc] initWithItem:item];
    [M8MeetWindow M8_addLiveSource:liveVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
}


- (void)sendCustomMsg {
    TILLiveManager *manager = [TILLiveManager getInstance];
    
    ILVLiveCustomMessage *customMsg = [ILVLiveCustomMessage new];
    customMsg.sendId = @"user1";
    customMsg.recvId = @"user2";
    NSDictionary *dataDic = @{@"roomId" : @"876543", @"topic" : _topic, @"host" : @"user1"};
    NSString *dataStr = [[NSString alloc] initWithFormat:@"%@", dataDic];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    customMsg.data = data;
    WCWeakSelf(self);
    
    [manager sendCustomMessage:customMsg succ:nil failed:^(NSString *module, int errId, NSString *errMsg) {
        [weakself sendCustomMsg];
    }];
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
    _topic = topic;
}

- (void)luanchTableViewMeetingCoverImg:(UIImage *)coverImg {
    _coverImg = coverImg;
}

- (void)luanchTableViewMeetingCurrentMembers:(NSArray *)currentMembers {
    
    [self.selectedArray removeAllObjects];
    // 添加自己
    [self.selectedArray addObject:[[ILiveLoginManager getInstance] getLoginId]];
    // 添加选中用户
    [self.selectedArray addObjectsFromArray:currentMembers];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
