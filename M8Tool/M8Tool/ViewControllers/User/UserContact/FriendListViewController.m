//
//  FriendListViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "FriendListViewController.h"
#import "UsrContactFriendCell.h"

@interface FriendListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FriendListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"我的好友"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onNetGetFriendList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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


- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = WCClear;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];   // 不能使用CGRectZero，不起作用
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsrContactFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UsrContactFriendCell" owner:nil options:nil] firstObject];
    }
    
    if (indexPath.row < self.dataArray.count)
    {
        M8MemberInfo *info = self.dataArray[indexPath.row];
        [cell configWithMemberItem:info];
    }
    
    return cell;
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











/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
