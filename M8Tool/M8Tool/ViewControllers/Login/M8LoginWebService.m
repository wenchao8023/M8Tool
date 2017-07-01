//
//  M8LoginWebService.m
//  M8Tool
//
//  Created by chao on 2017/6/30.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService.h"

#import "M8LoginWebService+UI.h"

@implementation M8LoginWebService


/**
 登录

 @param identifier 用户
 @param password 密码
 @param cancelHandle 取消加载视图
 */
- (void)M8LoginWithIdentifier:(NSString *)identifier password:(NSString *)password cancelPVN:(M8LoginHandle _Nullable)cancelHandle
{
    [self M8LoginWithIdentifier:identifier password:password succ:cancelHandle fail:cancelHandle];
}

- (void)M8LoginWithIdentifier:(NSString *)identifier password:(NSString *)password succ:(M8LoginHandle _Nullable)succHandle fail:(M8LoginHandle _Nullable)failHandle
{
    // 这里不能用 weakSelf, 到里面的时候是空的
//    __block __weak typeof(self) ws = self;
    
    //请求sig
    LoginRequest *sigReq = [[LoginRequest alloc] initWithHandler:^(BaseRequest *request) {
        LoginResponceData *responseData = (LoginResponceData *)request.response.data;
        [AppDelegate sharedAppDelegate].token = responseData.token;
        
        [[ILiveLoginManager getInstance] iLiveLogin:identifier sig:responseData.userSig succ:^{
            
            [self onLoginSucc:identifier password:password];
            
            // 登录成功
            if (succHandle) {
                succHandle();
            }
            
        } failed:^(NSString *module, int errId, NSString *errMsg) {
           
            if (errId == 8050)//离线被踢,再次登录
            {
                [self M8LoginWithIdentifier:identifier password:password succ:succHandle fail:failHandle];
            }
            else
            {
                NSString *errInfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
                [self onLoginFailAlertInfo:errInfo];
//                [AlertHelp alertWith:@"登录失败" message:errInfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
            }
            
            if (failHandle) {
                failHandle();
            }
        }];
    } failHandler:^(BaseRequest *request) {
        
        NSString *errInfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode, request.response.errorInfo];
        [self onLoginFailAlertInfo:errInfo];
        
        if (failHandle) {
            failHandle();
        }
//        NSString *errInfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode, request.response.errorInfo];
//        [AlertHelp alertWith:@"登录失败" message:errInfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
    }];
    sigReq.identifier = identifier;
    sigReq.pwd = password;
    [[WebServiceEngine sharedEngine] asyncRequest:sigReq];
}



/**
 注册

 @param identifier 用户ID
 @param nick 昵称
 @param pwd 密码
 @param cancelHandle 取消加载视图
 */
- (void)registWithIdentifier:(NSString *)identifier nick:(NSString *)nick pwd:(NSString *)pwd cancelHandle:(M8LoginHandle)cancelHandle {
   
    RegistRequest *registReq = [[RegistRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        if (cancelHandle) {
            cancelHandle();
        }
        
    } failHandler:^(BaseRequest *request) {
        
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        [self onRegistFailAlertInfo:errinfo];
//        NSLog(@"regist fail.%@",errinfo);
//        [AlertHelp alertWith:@"注册失败" message:errinfo cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        
        
        if (cancelHandle) {
            cancelHandle();
        }
    }];
    registReq.nick = nick;
    registReq.identifier = identifier;
    registReq.pwd = pwd;
    [[WebServiceEngine sharedEngine] asyncRequest:registReq];
}


@end
