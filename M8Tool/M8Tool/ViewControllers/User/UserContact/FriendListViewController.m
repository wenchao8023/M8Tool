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
            [self.selectButon setAttributedTitle:[CommonUtil customAttString:buttonStr fontSize:kAppMiddleFontSize textColor:WCWhite charSpace:kAppKern_2] forState:UIControlStateNormal];
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
            
        }
            break;

        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)onSelectMembersAction
{
    WCLog(@"选择好友添加");
    
    NSArray *viewControllers = self.navigationController.viewControllers;
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



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    WCLog(@"didShowViewController : %@", [viewController class]);
    
    //选人之后退出界面需要清空 selectArray 中的数据
    if ([NSStringFromClass([viewController class]) isEqualToString:@"UserContactViewController"])
    {
        M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
        [modelManger removeSelectMembers];
    }
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
