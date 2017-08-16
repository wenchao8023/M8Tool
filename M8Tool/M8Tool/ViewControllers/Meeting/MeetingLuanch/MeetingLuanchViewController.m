//
//  MeetingLuanchViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchViewController.h"
#import "MeetingLuanchTableView.h"

//#import "M8UploadImageHelper.h"

#import "M8MeetWindow.h"
#import "M8CallViewController.h"
#import "M8LiveViewController.h"


@interface MeetingLuanchViewController ()<LuanchTableViewDelegate, UINavigationControllerDelegate>
{
    UIImage *_coverImg;
    NSString *_topic;
    NSInteger _limitMembersByType;  //根据类型添加成员人数限制
}

@property (nonatomic, strong) MeetingLuanchTableView *tableView;

@property (nonatomic, strong) UIButton *luanchButton;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation MeetingLuanchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
    
    self.navigationController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.WCDelegate = self;
    
    [self createUI];
    
    [self configTabelViewArgu];
}

//视图消失之后，如果是在会议中，则需要显示tabBar
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([M8UserDefault getIsInMeeting])
    {
        UINavigationController *curNavi = [[AppDelegate sharedAppDelegate] navigationViewController];
        curNavi.tabBarController.tabBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setIsBackFromSelectContact:(BOOL)isBackFromSelectContact
{
    _isBackFromSelectContact = isBackFromSelectContact;
    
    //如果为真的时候就表示是从通讯录选人模式下返回，这时需要从新组装数据
    if (isBackFromSelectContact)
    {
        [self.tableView shouldReloadDataFromSelectContact:^{
            
            _isBackFromSelectContact = NO;
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger removeSelectMembers];
        }];
    }
}


- (void)createUI
{
    // 添加 tableView
    [self tableView];
    // 添加 发起按钮
    [self luanchButton];
}

- (MeetingLuanchTableView *)tableView
{
    if (!_tableView)
    {
        CGRect frame = self.contentView.bounds;
        frame.size.height -= (kDefaultMargin + kDefaultCellHeight);     // 减去 底部按钮所占的高度
        MeetingLuanchTableView *tableView = [[MeetingLuanchTableView alloc] initWithFrame:frame
                                                                                    style:UITableViewStyleGrouped];
        tableView.WCDelegate = self;
        [self.contentView addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray)
    {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}

- (UIButton *)luanchButton
{
    if (!_luanchButton)
    {
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
        luanchButton.enabled = NO;
        [luanchButton setBackgroundColor:WCButtonColor];
        [self.contentView addSubview:(_luanchButton = luanchButton)];

    }
    return _luanchButton;
}

- (void)luanchMeetingAction
{
    if ([CommonUtil alertTipInMeeting])
    {
        return ;
    }
    
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
    
    [self luanchMeeting];
}

    
/**
 发起会议
 */
- (void)luanchMeeting
{
    switch (self.luanchMeetingType)
    {
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
- (void)luanchCall:(TILCallType)callType
{
    //通知 inviteArray单例，这里要发起会议了，如果数组中没有成员，则需要从MeetingMembersCollection的数组中添加
    [self.tableView loadDataWithLuanchCall];
    
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在请求房间ID"];
    [self.view addSubview:reqIdWaitView];
    __block CallRoomResponseData *roomData = nil;
    __block NSString *imageUrl = nil;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        //请求房间号
        CallRoomRequest *callRoomReq = [[CallRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
            
            roomData = (CallRoomResponseData *)request.response.data;
            dispatch_semaphore_signal(semaphore);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [reqIdWaitView removeFromSuperview];
                int callId = [roomData.callId intValue];
                [self enterCall:callId imageUrl:imageUrl callType:callType];
            });
            
        } failHandler:^(BaseRequest *request) {
            
            dispatch_semaphore_signal(semaphore);
        }];
        
        callRoomReq.token = [AppDelegate sharedAppDelegate].token;
        [[WebServiceEngine sharedEngine] AFAsynRequest:callRoomReq];
    });
}

- (void)enterCall:(int)roomId imageUrl:(NSString *)coverUrl callType:(TILCallType)callType
{
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid = [M8UserDefault getLoginId];
    item.members = self.selectedArray;
    item.callType = callType;
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title = _topic;
    item.info.type = (callType == TILCALL_TYPE_VIDEO ? @"call_video" : @"call_audio");
    item.info.roomnum = roomId;
    item.info.groupid = [NSString stringWithFormat:@"%d", roomId];
    item.info.cover = coverUrl ? coverUrl : @"";
    item.info.appid = [ILiveAppId intValue];
    item.info.host = [M8UserDefault getLoginId];
    
    M8CallViewController *callVC = [[M8CallViewController alloc] initWithItem:item isHost:YES];
    [M8MeetWindow M8_addMeetSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController] succHandle:^{
        
        UINavigationController *curNavi = self.navigationController;
        if ([self respondsToSelector:@selector(configBottomTipView)])
        {
            [self performSelector:@selector(configBottomTipView)];
            curNavi.tabBarController.tabBar.hidden = YES;
        }
    }];
}


/**
 发起直播会议
 */
- (void)luanchLiving
{
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在请求房间ID"];
    [self.view addSubview:reqIdWaitView];
    __block CreateRoomResponceData *roomData = nil;
//    __block NSString *imageUrl = nil;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        // 请求房间号
        CreateRoomRequest *createRoomReq = [[CreateRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
            
            roomData = (CreateRoomResponceData *)request.response.data;
//            dispatch_semaphore_signal(semaphore);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [reqIdWaitView removeFromSuperview];
                [self enterLive:(int)roomData.roomnum groupId:roomData.groupid imageUrl:@""];
            });
            
        } failHandler:^(BaseRequest *request) {
            
//            dispatch_semaphore_signal(semaphore);
        }];
        
        createRoomReq.token = [AppDelegate sharedAppDelegate].token;
        createRoomReq.type = @"live";
        [[WebServiceEngine sharedEngine] AFAsynRequest:createRoomReq];
        
        //上传图片
//        [[M8UploadImageHelper shareInstance] upload:_coverImg completion:^(NSString *imageSaveUrl) {
//            
//            imageUrl = imageSaveUrl;
//            dispatch_semaphore_signal(semaphore);
//            
//        } failed:^(NSString *failTip) {
//            
//            dispatch_semaphore_signal(semaphore);
//        }];
//        
//        dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC));
//        dispatch_semaphore_wait(semaphore, timeoutTime);
//        dispatch_semaphore_wait(semaphore, timeoutTime);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [reqIdWaitView removeFromSuperview];
//            [self enterLive:(int)roomData.roomnum groupId:roomData.groupid imageUrl:@""];
//        });
    });
}

- (void)enterLive:(int)roomId groupId:(NSString *)groupid imageUrl:(NSString *)coverUrl
{
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid = [M8UserDefault getLoginId];
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title = _topic;
    item.info.type = @"live";
    item.info.roomnum = roomId;
    item.info.groupid = groupid;
    item.info.cover = coverUrl ? coverUrl : @"";
    item.info.appid = [ILiveAppId intValue];
    item.info.host = [M8UserDefault getLoginId];
    
    M8LiveViewController *liveVC = [[M8LiveViewController alloc] initWithItem:item isHost:YES];
    [M8MeetWindow M8_addMeetSource:liveVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController] succHandle:^{
        
        UINavigationController *curNavi = self.navigationController;
        if ([self respondsToSelector:@selector(configBottomTipView)])
        {
            //视图推出的动画是 0.3s 所以 0.3s 之后执行这段代码
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [self performSelector:@selector(configBottomTipView)];
                curNavi.tabBarController.tabBar.hidden = YES;
            });
        }
    }];
}


- (void)sendCustomMsg
{
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
- (NSString *)getTitle
{
    switch (self.luanchMeetingType)
    {
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

- (void)configTabelViewArgu
{
    switch (self.luanchMeetingType)
    {
        case LuanchMeetingType_phone:
            _limitMembersByType = 5;
            break;
        case LuanchMeetingType_video:
            _limitMembersByType = 3;

            break;
        case LuanchMeetingType_live:
            _limitMembersByType = 0;
            self.luanchButton.enabled = YES;
            break;
        case LuanchMeetingType_order:
            _limitMembersByType = 100;

            break;
        default:
            break;
    }
    
    self.tableView.isHiddenFooter = (self.luanchMeetingType == LuanchMeetingType_live);
    self.tableView.MaxMembers = _limitMembersByType;
}

    
#pragma mark - LuanchTableViewDelegate
- (void)luanchTableViewMeetingTopic:(NSString *)topic
{
    _topic = topic;
}

- (void)luanchTableViewMeetingCoverImg:(UIImage *)coverImg
{
    _coverImg = coverImg;
}

- (void)luanchTableViewMeetingCurrentMembers:(NSArray *)currentMembers
{
    self.luanchButton.enabled = (currentMembers.count > 0 && currentMembers.count <= self.tableView.MaxMembers);
    
    [self.selectedArray removeAllObjects];
    // 添加自己
    [self.selectedArray addObject:[M8UserDefault getLoginId]];
    // 添加选中用户
    [self.selectedArray addObjectsFromArray:currentMembers]
;
}

#pragma mark -- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    WCLog(@"didShowViewController : %@", [viewController class]);
    
    //如果是在直播中，这里不应该清空数据
    if ([M8UserDefault getIsInMeeting])
    {
        return ;
    }
    
    //选人之后退出界面需要清空所有数据
    if ([NSStringFromClass([viewController class]) isEqualToString:@"MeetingViewController"])
    {
        M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
        [modelManger removeAllMembers];
    }
}

@end
