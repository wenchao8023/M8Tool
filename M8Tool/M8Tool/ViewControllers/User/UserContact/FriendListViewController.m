//
//  FriendListViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "FriendListViewController.h"
#import "UsrContactFriendCell.h"

#import "MeetingLuanchViewController.h"

@interface FriendListViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    BOOL _isInviteBack;     //判断是不是会议中邀请好友的时候 点击返回，如果是则返回数据，跳过代理，如果不是，就是退出，应该清空数据
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *selectButon;



@end

@implementation FriendListViewController

#pragma mark - inits
- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect frame = self.contentView.bounds;
        if (self.contactType == ContactType_sel ||
            self.contactType == ContactType_invite)
        {
            frame.size.height -= (kDefaultMargin + kDefaultCellHeight);
        }
    
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = WCClear;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];   // 不能使用CGRectZero，不起作用
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    
    return _tableView;
}

- (UIButton *)selectButon
{
    if (!_selectButon)
    {
        UIButton *luanchButton = [WCUIKitControl createButtonWithFrame:CGRectMake(kDefaultMargin,
                                                                                  self.contentView.height - kDefaultMargin - kDefaultCellHeight,
                                                                                  self.contentView.width - 2 * kDefaultMargin,
                                                                                  kDefaultCellHeight)
                                                                Target:self
                                                                Action:@selector(onSelectMembersAction)
                                                                 Title:@"选择"];
        [luanchButton setAttributedTitle:[CommonUtil customAttString:luanchButton.titleLabel.text
                                                            fontSize:kAppNaviFontSize
                                                           textColor:WCWhite
                                                           charSpace:kAppKern_2]
                                forState:UIControlStateNormal];
        WCViewBorder_Radius(luanchButton, kDefaultCellHeight / 2);
        [luanchButton setBackgroundColor:WCButtonColor];
        [self.contentView addSubview:luanchButton];
    }
    return _selectButon;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

#pragma mark - view life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    [self setHeaderTitle:@"我的好友"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onNetGetFriendList];
    
    [self createUI];
    
    [WCNotificationCenter addObserver:self.tableView selector:@selector(reloadData) name:kNewFriendStatu_Notification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [M8UserDefault setNewFriendNotify:NO];
    [M8UserDefault setNewFriendIdentify:[NSArray array]];
    [WCNotificationCenter postNotificationName:kNewFriendStatu_Notification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIKit
- (void)createUI
{
    [self tableView];
    
    if (self.contactType == ContactType_sel ||
        self.contactType == ContactType_invite)
    {
        self.selectButon.hidden = YES;
    }
}


#pragma mark - on network
- (void)onNetGetFriendList
{
//    [self.dataArray removeAllObjects];
//    
//    WCWeakSelf(self);
//    
//    TIMFriendshipManager *frdManger = [TIMFriendshipManager sharedInstance];
//    
//    [frdManger GetFriendList:^(NSArray *friends) {
//    
//        [self.dataArray addObjectsFromArray:friends];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//            [weakself.tableView reloadData];
//        });
//        
//    } fail:^(int code, NSString *msg) {
//        
//    }];
    [self.dataArray removeAllObjects];
    WCWeakSelf(self);
    FriendsListRequest *friendListReq = [[FriendsListRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        FriendsListRequest *wreq = (FriendsListRequest *)request;
        FriendsListResponceData *respData = (FriendsListResponceData *)wreq.response.data;
        
        for (NSDictionary *dic in respData.InfoItem)
        {   
            M8MemberInfo *info = [M8MemberInfo new];
            info.uid    = [dic objectForKey:@"Info_Account"];
            info.nick   = [[[dic objectForKey:@"SnsProfileItem"] firstObject] objectForKey:@"Value"];
            [weakself.dataArray addObject:info];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself.tableView reloadData];
        });
        
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    friendListReq.identifier = [M8UserDefault getLoginId];
    friendListReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] AFAsynRequest:friendListReq];
}

- (void)onNetDeleteFriend:(NSIndexPath *)indexPath
{
    M8MemberInfo *mInfo = self.dataArray[indexPath.row];
    WCWeakSelf(self);
    DeleteFriendReuqest *delFReq = [[DeleteFriendReuqest alloc] initWithHandler:^(BaseRequest *request) {
        
        [weakself onNetGetFriendList];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    delFReq.token = [AppDelegate sharedAppDelegate].token;
    delFReq.uid   = [M8UserDefault getLoginId];
    delFReq.fid   = mInfo.uid;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:delFReq];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsrContactFriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID"];
    
    if (!friendCell)
    {
        friendCell = [[[NSBundle mainBundle] loadNibNamed:@"UsrContactFriendCell" owner:nil options:nil] firstObject];
    }
    
    if (indexPath.row < self.dataArray.count)
    {
        if (self.contactType == ContactType_sel ||
            self.contactType == ContactType_invite)
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            
            M8MemberInfo *info = self.dataArray[indexPath.row];
            if ([modelManger isExistInviteArray:info.uid])
            {
                [friendCell configMemberitemUnableUnselect:info];
            }
            else if ([modelManger isExistSelectArray:info.uid])
            {
                [friendCell configMemberItem:info isSelected:YES];
            }
            else
            {
                [friendCell configMemberItem:info isSelected:NO];
            }
        }
        else
        {
            [friendCell configWithMemberItem:self.dataArray[indexPath.row]];
        }
    }
    
    return friendCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.contactType)
    {
        case ContactType_sel :
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger onSelectAtMemberInfo:self.dataArray[indexPath.row]];
            
            [self.tableView reloadData];
            
            NSInteger selectNum = modelManger.selectMemberArray.count;
            
            NSString *buttonStr = nil;
            if (selectNum)
            {
                buttonStr = [NSString stringWithFormat:@"选择(%ld)人", (long)selectNum];
            }
            else
            {
                buttonStr = @"选择";
            }
            self.selectButon.enabled = (selectNum > 0);
            
            [UIView setAnimationsEnabled:NO];
            [self.selectButon setAttributedTitle:[CommonUtil customAttString:buttonStr
                                                                    fontSize:kAppMiddleFontSize
                                                                   textColor:WCWhite
                                                                   charSpace:kAppKern_2]
                                        forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
            
        }
            break;
        case ContactType_tel :
        {
            M8MemberInfo *info = self.dataArray[indexPath.row];
            [CommonUtil makePhone:info.uid];
        }
            break;
        case ContactType_contact :
        {
            
        }
            break;
        case ContactType_invite:
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger onSelectAtMemberInfo:self.dataArray[indexPath.row]];
            
            [self.tableView reloadData];
            
            NSInteger selectNum = modelManger.selectMemberArray.count;
            
            NSString *buttonStr = nil;
            if (selectNum)
            {
                buttonStr = [NSString stringWithFormat:@"选择(%ld)人", (long)selectNum];
            }
            else
            {
                buttonStr = @"选择";
            }
            self.selectButon.enabled = (selectNum > 0);
            
            [UIView setAnimationsEnabled:NO];
            [self.selectButon setAttributedTitle:[CommonUtil
                                                  customAttString:buttonStr
                                                  fontSize:kAppMiddleFontSize
                                                  textColor:WCWhite
                                                  charSpace:kAppKern_2]
                                        forState:UIControlStateNormal];
            [UIView setAnimationsEnabled:YES];
        }
            break;

        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -- 滑动删除cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contactType == ContactType_sel ||
        self.contactType == ContactType_invite)
    {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self onNetDeleteFriend:indexPath];
    }
}



- (void)onSelectMembersAction
{
    WCLog(@"选择好友添加");
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (self.contactType == ContactType_sel)
    {
        if (viewControllers.count > 3)
        {
            UIViewController *vc = [viewControllers objectAtIndex:viewControllers.count - 3];
            if ([vc isKindOfClass:[MeetingLuanchViewController class]])
            {
                MeetingLuanchViewController *luanchVC = (MeetingLuanchViewController *)vc;
                luanchVC.isBackFromSelectContact = YES;
                [self.navigationController popToViewController:luanchVC animated:YES];
            }
        }
    }
    else if (self.contactType == ContactType_invite)    //如果是邀请的则只需 popself 就ok了，然后弹出会议界面
    {
        _isInviteBack = YES;
        
        [WCNotificationCenter postNotificationName:kInviteMembers_Notifycation object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    WCLog(@"didShowViewController : %@", [viewController class]);
    
    //选人之后退出界面需要清空 selectArray 中的数据，邀请的时候不需要
    if (self.contactType == ContactType_sel)
    {
        if ([NSStringFromClass([viewController class]) isEqualToString:@"UserContactViewController"])
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger removeSelectMembers];
        }
    }
    
    if (self.contactType == ContactType_invite)
    {
        if (_isInviteBack)
        {
            return ;
        }
        else
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger removeSelectMembers];
        }
    }
    
}


- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kInviteMembers_Notifycation object:nil];
    [WCNotificationCenter removeObserver:self.tableView name:kNewFriendStatu_Notification object:nil];
    [WCNotificationCenter removeObserver:self name:kNewFriendStatu_Notification object:nil];
}

@end
