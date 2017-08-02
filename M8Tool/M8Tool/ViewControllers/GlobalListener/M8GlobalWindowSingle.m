//
//  M8GlobalWindowSingle.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalWindowSingle.h"

#import "M8GlobalAlert.h"
#import "M8LoginWebService.h"


@interface M8GlobalWindowSingle ()<GlobalAlertDelegate>

@property (nonatomic, strong) M8GlobalAlert *alertView;
@property (nonatomic, strong) UIWindow      *alertWindow;


@end



@implementation M8GlobalWindowSingle

+ (instancetype)shareInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (UIWindow *)alertWindow
{
    if (!_alertWindow)
    {
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        
        
        UIImageView *bgImg  = [WCUIKitControl createImageViewWithFrame:alertWindow.bounds ImageName:@"globalAlertBgImg" BgColor:WCClear];
        [alertWindow addSubview:bgImg];
        
        
        [alertWindow makeKeyAndVisible];
        
        _alertWindow = alertWindow;
    }
    
    return _alertWindow;
}





- (void)addAlertInfo:(NSString *)alertInfo alertType:(GlobalAlertType)alertType
{
    [self alertWindow];
    
    
    self.alertView = [[M8GlobalAlert alloc] initWithFrame:CGRectMake(0, 0, self.alertWindow.width * 0.7, 0) alertInfo:alertInfo alertType:alertType];
    self.alertView.WCDelegate = self;
    
    
    [self.alertWindow addSubview:self.alertView];
}


- (void)onGlobalAlertLeftButtonAction
{
    WCLog(@"退出");
    
    [self.alertView removeFromSuperview];
    self.alertView   = nil;
    self.alertWindow = nil;
    
    [M8UserDefault setUserLogout:YES];
    
    [[AppDelegate sharedAppDelegate] enterLoginUI];
}


- (void)onGlobalAlertRightButtonAction
{
    WCLog(@"重新登录");
    
//    if ([CommonUtil alertTipInMeeting]) //会议中 得思考
//    {
//        return ;
//    }
    
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    
    LoadView *loginWaitView = [LoadView loadViewWith:@"正在登录"];
    [self.alertWindow addSubview:loginWaitView];
    M8LoginWebService *webService = [[M8LoginWebService alloc] init];
    LastLoginType loginType = [M8UserDefault getLastLoginType];
    
    WCWeakSelf(self);
    if (loginType == LastLoginType_phone)
    {
        NSString *name  = [M8UserDefault getLoginId];
        NSString *pwd   = [M8UserDefault getLoginPwd];
        
        [webService M8ReLoginWithIdentifier:name password:pwd cancelPVN:^{
            
            [loginWaitView removeFromSuperview];
            
            for (UIView *subView in weakself.alertWindow.subviews)
            {
                [subView removeFromSuperview];
            }
            
            weakself.alertWindow = nil;
        }];
    }
    else if (loginType == LastLoginType_QQ)
    {
        NSString *openid  = [M8UserDefault getLoginId];
        NSString *nick   = [M8UserDefault getLoginNick];
        
        [webService M8QQReLoginWithOpenId:openid nick:nick cancelPVN:^{
            
            [loginWaitView removeFromSuperview];
        }];
    }
    
}



@end
