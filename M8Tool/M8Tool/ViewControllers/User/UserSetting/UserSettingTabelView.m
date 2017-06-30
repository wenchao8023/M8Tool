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
    
    LoadView *logoutWaitView = [LoadView loadViewWith:@"正在退出"];
    [self addSubview:logoutWaitView];
    
    __weak typeof(self) ws = self;
    //通知业务服务器登出
    LogoutRequest *logoutReq = [[LogoutRequest alloc] initWithHandler:^(BaseRequest *request) {
        [[ILiveLoginManager getInstance] iLiveLogout:^{
            [logoutWaitView removeFromSuperview];
            [ws deleteLoginParamFromLocal];
            [ws enterLoginUI];
            
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            [logoutWaitView removeFromSuperview];
            NSString *errinfo = [NSString stringWithFormat:@"module=%@,errid=%ld,errmsg=%@",module,(long)request.response.errorCode,request.response.errorInfo];
            NSLog(@"regist fail.%@",errinfo);
            [AlertHelp alertWith:@"退出失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        }];
    } failHandler:^(BaseRequest *request) {
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        NSLog(@"regist fail.%@",errinfo);
        [logoutWaitView removeFromSuperview];
        [AlertHelp alertWith:@"退出失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
    }];
    
    logoutReq.token = [AppDelegate sharedAppDelegate].token;
    [[WebServiceEngine sharedEngine] asyncRequest:logoutReq];
}

- (void)enterLoginUI {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UINavigationController *navi = kM8LoginNaViewController(kM8LoginViewController);
//    UIViewController *loginVC = navi.topViewController;
//    [loginVC setValue:[NSNumber numberWithBool:YES] forKey:@"isLogout"];
//    appDelegate.window.rootViewController = navi;
//    [appDelegate.window makeKeyWindow];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navi = kM8LoginNaViewController(kM8MutiLoginViewController);
    appDelegate.window.rootViewController = navi;
    [appDelegate.window makeKeyWindow];
}


- (void)deleteLoginParamFromLocal
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kLoginParam];
}

@end
