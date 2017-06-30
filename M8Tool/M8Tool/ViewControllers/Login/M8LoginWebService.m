//
//  M8LoginWebService.m
//  M8Tool
//
//  Created by chao on 2017/6/30.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService.h"


@implementation M8LoginWebService

- (void)M8LoginWithIdentifier:(NSString *)identifier password:(NSString *)password succ:(M8LoginHandle _Nullable)succHandle fail:(M8LoginHandle _Nullable)failHandle
{
    __weak typeof(self) ws = self;
    //请求sig
    LoginRequest *sigReq = [[LoginRequest alloc] initWithHandler:^(BaseRequest *request) {
        LoginResponceData *responseData = (LoginResponceData *)request.response.data;
        [AppDelegate sharedAppDelegate].token = responseData.token;
        [[ILiveLoginManager getInstance] iLiveLogin:identifier sig:responseData.userSig succ:^{
            
            if (succHandle) {
                
            }
//            [loginWaitView removeFromSuperview];
//            [self setUserDefault];
//            [ws enterMainUI];
            
        } failed:^(NSString *module, int errId, NSString *errMsg) {
//            [loginWaitView removeFromSuperview];
            if (errId == 8050)//离线被踢,再次登录
            {
//                [ws loginName:identifier pwd:pwd];
//                [ws M8LoginWithIdentifier:identifier password:password];
            }
            else
            {
                NSString *errInfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
                NSLog(@"login fail.%@",errInfo);
                [AlertHelp alertWith:@"登录失败" message:errInfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
            }
        }];
    } failHandler:^(BaseRequest *request) {
//        [loginWaitView removeFromSuperview];
        NSString *errInfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode, request.response.errorInfo];
        NSLog(@"login fail.%@",errInfo);
        [AlertHelp alertWith:@"登录失败" message:errInfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
    }];
    sigReq.identifier = identifier;
    sigReq.pwd = password;
    [[WebServiceEngine sharedEngine] asyncRequest:sigReq];
}

@end
