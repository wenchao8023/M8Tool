//
//  M8RecordDetailViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecordDetailViewController.h"
#import "M8RecordDetailTableView.h"

#import "M8MeetRecordModel.h"

#import "M8MeetWindow.h"
#import "M8CallViewController.h"
#import "M8LiveViewController.h"



@interface M8RecordDetailViewController ()

@property (nonatomic, strong) M8RecordDetailTableView *detailTableView;

@property (nonatomic, strong) UIButton *reluanchBtn;

@property (nonatomic, strong) M8MeetRecordModel *dataModel;

@end

@implementation M8RecordDetailViewController

- (instancetype)initWithDataModel:(M8MeetRecordModel *)dataModel
{
    if (self = [super init])
    {
        _dataModel = dataModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"会议详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.contentView addSubview:self.detailTableView];
    [self.view bringSubviewToFront:self.reluanchBtn];
}

- (M8RecordDetailTableView *)detailTableView
{
    if (!_detailTableView)
    {
        M8RecordDetailTableView *detailTableView = [[M8RecordDetailTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain dataModel:_dataModel];
        _detailTableView = detailTableView;
    }
    return _detailTableView;
}

- (UIButton *)reluanchBtn
{
    if (!_reluanchBtn)
    {
        UIButton *reluanchBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(0, 0, 80, 40)
                                                               Target:self
                                                               Action:@selector(reluanchAction)
                                                            ImageName:@""
                                 ];
        [reluanchBtn setCenterX:self.view.centerX];
        [reluanchBtn setY:CGRectGetMaxY(self.contentView.frame) - 40];
        [reluanchBtn setBackgroundImage:kGetImage(@"recordreluanch") forState:UIControlStateNormal];
        [self.view addSubview:(_reluanchBtn = reluanchBtn)];
    }
    return _reluanchBtn;
}

- (void)reluanchAction
{
    if ([CommonUtil alertTipInMeeting])
    {
        return ;
    }
    
    
    if ([_dataModel.type isEqualToString:@"live"])
    {
        
    }
    if ([_dataModel.type isEqualToString:@"call_audio"])
    {
        [self luanchCall:TILCALL_TYPE_AUDIO];
    }
    if ([_dataModel.type isEqualToString:@"call_video"])
    {
        [self luanchCall:TILCALL_TYPE_VIDEO];
    }
}

- (void)luanchCall:(TILCallType)callType
{
    LoadView *reqIdWaitView = [LoadView loadViewWith:@"正在请求房间ID"];
    [self.view addSubview:reqIdWaitView];
    __block CallRoomResponseData *roomData = nil;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        //请求房间号
        CallRoomRequest *callRoomReq = [[CallRoomRequest alloc] initWithHandler:^(BaseRequest *request) {
            roomData = (CallRoomResponseData *)request.response.data;
            dispatch_semaphore_signal(semaphore);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [reqIdWaitView removeFromSuperview];
                int callId = [roomData.callId intValue];
                [self enterCall:callId callType:callType];
            });
            
        } failHandler:^(BaseRequest *request) {
            dispatch_semaphore_signal(semaphore);
        }];
        callRoomReq.token = [AppDelegate sharedAppDelegate].token;
        [[WebServiceEngine sharedEngine] AFAsynRequest:callRoomReq];
    });
}

- (void)enterCall:(int)roomId callType:(TILCallType)callType
{
    NSString *loginId = [M8UserDefault getLoginId];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataModel.members];
    
    //加载数据，数据格式要与会议发起的那里一致，将自己放在数组的最前面
    for (int i = 0; i < tempArr.count; i++)
    {
        M8MeetMemberInfo *info = tempArr[i];
        if ([info.user isEqualToString:loginId] &&
            i != 0)
        {
            [tempArr exchangeObjectAtIndex:i withObjectAtIndex:0];
        }
    }
    
    NSMutableArray *inviteArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *membersArr = [NSMutableArray arrayWithCapacity:0];
    for (M8MeetMemberInfo *info in tempArr)
    {
        [membersArr addObject:info.user];
        
        M8MemberInfo *memInfo = [[M8MemberInfo alloc] init];
        memInfo.uid = info.user;
        memInfo.nick = info.nick;
        [inviteArr addObject:memInfo];
    }
    
    M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
    [modelManger updateInviteMemberArray:inviteArr];
    
    TCShowLiveListItem *item = [[TCShowLiveListItem alloc] init];
    item.uid = [M8UserDefault getLoginId];
    item.members = membersArr;
    item.callType = callType;
    item.info = [[ShowRoomInfo alloc] init];
    item.info.title = _dataModel.title;
    item.info.type = (callType == TILCALL_TYPE_VIDEO ? @"call_video" : @"call_audio");
    item.info.roomnum = roomId;
    item.info.groupid = [NSString stringWithFormat:@"%d", roomId];
    item.info.appid = [ILiveAppId intValue];
    item.info.host = loginId;
    
    M8CallViewController *callVC = [[M8CallViewController alloc] initWithItem:item isHost:YES];
    [M8MeetWindow M8_addMeetSource:callVC WindowOnTarget:[[AppDelegate sharedAppDelegate].window rootViewController]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
