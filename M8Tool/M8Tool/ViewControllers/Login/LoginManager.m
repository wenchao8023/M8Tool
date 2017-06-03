//
//  LoginManager.m
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

- (void)autoLogin
{
    NSDictionary *dic = [self getLocalLoginParam];
    if (dic)
    {
        NSString *identifier = [dic objectForKey:kLoginIdentifier];
        NSString *passward = [dic objectForKey:kLoginPassward];
        if (identifier.length > 0 && passward.length > 0)
        {
            [self login:identifier passward:passward click:NO];
        }
    }
}

- (void)login:(NSString *)identifier passward:(NSString *)pwd click:(BOOL)isClick
{
    WCWeakSelf(self)
    //请求sig
    LoginRequest *sigReq = [[LoginRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        LoginResponceData *responseData = (LoginResponceData *)request.response.data;
        [AppDelegate sharedAppDelegate].token = responseData.token;
        [[ILiveLoginManager getInstance] iLiveLogin:identifier
                                                sig:responseData.userSig
                                               succ:^{
                                                   [weakself saveLoginParamToLocal:identifier passward:pwd];
                                                   weakself.loginTypeBlock(LoginType_Succ);
                                               }
                                             failed:^(NSString *module, int errId, NSString *errMsg) {
                                                 if (isClick) {
                                                     [self login:identifier passward:pwd click:isClick];
                                                 }
                                                 else {
                                                    weakself.loginTypeBlock(LoginType_Busy);
                                                 }
                                             }];
    } failHandler:^(BaseRequest *request) {
//        NSString *errInfo = [NSString stringWithFormat:
//                             @"errid=%ld,errmsg=%@",
//                             (long)request.response.errorCode,
//                             request.response.errorInfo];
        weakself.loginTypeBlock(LoginType_Fail);
    }];
    
    sigReq.identifier   = identifier;
    sigReq.pwd          = pwd;
    [[WebServiceEngine sharedEngine] asyncRequest:sigReq];
}


- (void)saveLoginParamToLocal:(NSString *)identifier passward:(NSString *)pwd
{
    NSMutableDictionary *loginParam = [NSMutableDictionary dictionary];
    [loginParam setObject:identifier forKey:kLoginIdentifier];
    [loginParam setObject:pwd forKey:kLoginPassward];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:loginParam forKey:kLoginParam];
    [userDefaults synchronize];
}
- (NSDictionary *)getLocalLoginParam
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:kLoginParam];
    return dic;
}


@end
