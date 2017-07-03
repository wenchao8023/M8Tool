//
//  UsrContactView.m
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"
#import "UsrContactHeaderView.h"


static const CGFloat kHeaderHeight = 60;


@interface UsrContactView ()<UITableViewDelegate, UITableViewDataSource>
{
    UsrContactHeaderView *_headView;
}
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end


@implementation UsrContactView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = WCClear;
        _headView = [[UsrContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, kHeaderHeight)];
        self.tableHeaderView = _headView;
        
        WCWeakSelf(self);
        [self loadData:^{
            [weakself reloadData];
        }];
    }
    return self;
}


- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithCapacity:0];
        [_sectionArray addObjectsFromArray:@[@"研发部", @"销售部", @"市场部"]];
    }
    return _sectionArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
//        [_dataArray addObjectsFromArray:@[@[@"user1", @"user2", @"user3"],
//                                          @[@"user4", @"user5", @"user6"],
//                                          @[@"user7", @"user8", @"user9", @"user10"]
//                                          ]
//         ];
    }
    return _dataArray;
}


- (void)loadData:(TCIVoidBlock)complete {
    
    WCWeakSelf(self);
    FriendsListRequest *friendListReq = [[FriendsListRequest alloc] initWithHandler:^(BaseRequest *request) {
        FriendsListRequest *wreq = (FriendsListRequest *)request;
        [weakself loadListSucc:wreq];
        if (complete) {
            complete();
        }
        
    } failHandler:^(BaseRequest *request) {
        if (complete) {
            complete();
        }
    }];
    friendListReq.identifier = [[ILiveLoginManager getInstance] getLoginId];
    friendListReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] asyncRequest:friendListReq];
    
}

- (void)loadListSucc:(FriendsListRequest *)req {
    FriendsListResponceData *respData = (FriendsListResponceData *)req.response.data;
    
    [_headView configWithTitle:nil friendsNum:respData.FriendNum];
    
    [self.dataArray removeAllObjects];
    
    for (NSDictionary *dic in respData.InfoItem) {
        M8FriendInfo *info = [M8FriendInfo new];
        [info setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:info];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.sectionArray.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.dataArray && self.dataArray.count) {
//        return [self.dataArray[section] count];
//    }
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UsrContactViewID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = WCClear;
    }
    
    if (self.dataArray && self.dataArray.count /* &&
        self.dataArray[indexPath.section] && [self.dataArray[indexPath.section] count]*/) {
//        cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
        M8FriendInfo *info = self.dataArray[indexPath.row];
        cell.textLabel.text = info.Info_Account;
    }
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *hView = [WCUIKitControl createViewWithFrame:CGRectMake(0, 0, self.width, 40) BgColor:WCClear];
//    UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(kMarginView_horizontal, 0, 100, 40) BgColor:WCClear];
//    titleLabel.text = self.sectionArray[section];
//    [hView addSubview:titleLabel];
//    return hView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 40;
//}




@end
