//
//  UserTableView.m
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserTableView.h"

#import "UserTableViewCell.h"


static const CGFloat kHeadHeight = 100;

static NSString *const kUserCardVC      = @"UserCardViewController";
//static NSString *const kUserCardVC = @"UserCardViewController";
//static NSString *const kUserCardVC = @"UserCardViewController";
static NSString *const kUserThemeVC     = @"M8ThemeViewController";
static NSString *const kUserSettingVC   = @"UserSettingViewController";
//static NSString *const kUserCardVC = @"UserCardViewController";
//static NSString *const kUserCardVC = @"UserCardViewController";


/////////////////////////////////// 头部视图
@interface UserHeaderView : UIView


@end


@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WCBgColor;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(48, 20, 80, 20) Text:@"林瑞" BgColor:WCClear];
    [titleLabel setAttributedText:[CommonUtil customAttString:@"林瑞" fontSize:kAppLargeFontSize textColor:WCBlack charSpace:kAppKern_4]];
    [self addSubview:titleLabel];
    
    UILabel *LineLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5) Text:nil BgColor:[UIColor colorWithRed:0.86 green:0.84 blue:0.82 alpha:1]];
    [self addSubview:LineLabel];
}

@end
/////////////////////////////////// 头部视图


@interface UserTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *actionsAarry;

@end


@implementation UserTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.tableHeaderView = [WCUIKitControl createLabelWithFrame:CGRectZero];
        self.tableFooterView = [WCUIKitControl createLabelWithFrame:CGRectZero];
        self.backgroundColor = WCClear;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCellID"];
        
        [self loadData];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        _dataArray = dataArray;
    }
    return _dataArray;
}

- (NSArray *)actionsAarry {
    if (!_actionsAarry) {
        NSArray *actionsArray = @[@"onCardAction", @"onWalletAction", @"onSwichConyAction",
                                  @"onSwichThemeAction", @"onSettingAction", @"onCertificationAction", @"onOwnConyAction"];
        _actionsAarry = actionsArray;
    }
    return _actionsAarry;
}

- (void)loadData {
    NSArray *titleArr = @[@"我的名片", @"我的钱包", @"切换企业", @"桌面主题", @"设置", @"个人实名认证", @"所在企业"];
    NSArray *imgsArr  = @[@"userCard", @"userwallet", @"userSwitchCony", @"userTheme", @"userSetting", @"userCentification", @"userOwnCony"];
    
    for (int i = 0; i < titleArr.count; i++) {
        UserTableViewModel *model = [UserTableViewModel new];
        model.titleStr = titleArr[i];
        model.imgStr = imgsArr[i];
        [self.dataArray addObject:model];
    }
    
    [self reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCellID" forIndexPath:indexPath];
    
    [cell config:self.dataArray[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, kHeadHeight)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeadHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSelector:NSSelectorFromString(self.actionsAarry[indexPath.row]) withObject:indexPath afterDelay:0];
}


#pragma mark - actions
- (void)onCardAction {
    [self pushToViewController:kUserCardVC];
}

- (void)onWalletAction {
    
}

- (void)onSwichConyAction {
    
}

- (void)onSwichThemeAction {
    [self pushToViewController:kUserThemeVC];
}

- (void)onSettingAction {
    [self pushToViewController:kUserSettingVC];
}

- (void)onCertificationAction {
    
}

- (void)onOwnConyAction {
    
}

- (void)pushToViewController:(NSString *)viewControllerName {
    Class myClass = NSClassFromString(viewControllerName);
    BaseViewController *vc = [myClass new];
    vc.isExitLeftItem = YES;
    [[[AppDelegate sharedAppDelegate] navigationViewController] pushViewController:vc animated:YES];
}




@end
