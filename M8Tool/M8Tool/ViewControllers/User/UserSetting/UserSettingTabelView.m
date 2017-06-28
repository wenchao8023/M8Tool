//
//  UserSettingTabelView.m
//  M8Tool
//
//  Created by chao on 2017/5/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserSettingTabelView.h"


@interface UserSettingTabelView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *actionsArray;

@end

@implementation UserSettingTabelView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.tableFooterView    = [WCUIKitControl createViewWithFrame:CGRectZero];
        self.tableHeaderView    = [WCUIKitControl createViewWithFrame:CGRectZero];
        self.dataSource         = self;
        self.delegate           = self;
        self.scrollEnabled      = NO;
        self.backgroundColor    = WCClear;
        
    }
    return self;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSArray *dataArrray = @[@[@"密码设置", @"新消息设置", @"关于iBuild"],
                                @[@"退出"]];
        _dataArray = dataArrray;
    }
    return _dataArray;
}

- (NSArray *)actionsArray {
    if (!_actionsArray) {
        _actionsArray = @[@[@"onPwdSetAction", @"onNewMsgSetAction", @"onAboutAction"],
                          @[@"onLogoutAction"]];
    }
    return _actionsArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UserSettingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WCClear;
        [cell.textLabel setAttributedText:[CommonUtil customAttString:self.dataArray[indexPath.section][indexPath.row]
                                                             fontSize:kAppLargeFontSize
                                                            textColor:WCBlack
                                                            charSpace:kAppKern_4]
         ];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [WCUIKitControl createViewWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [WCUIKitControl createViewWithFrame:CGRectZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:NSSelectorFromString(self.actionsArray[indexPath.section][indexPath.row]) withObject:indexPath afterDelay:0];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - actions
- (void)onPwdSetAction {
    
}

- (void)onNewMsgSetAction {
    
}

- (void)onAboutAction {
    
}

- (void)onLogoutAction {
    WCWeakSelf(self);
    [[ILiveLoginManager getInstance] tlsLogout:^{
        [weakself enterLoginUI];
    } failed:nil];
}

- (void)enterLoginUI {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *loginVC = [[UIStoryboard storyboardWithName:@"M8LoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"M8LoginViewController"];
    [loginVC setValue:[NSNumber numberWithBool:YES] forKey:@"isLogout"];
    appDelegate.window.rootViewController = loginVC;
    [appDelegate.window makeKeyWindow];
}


@end
