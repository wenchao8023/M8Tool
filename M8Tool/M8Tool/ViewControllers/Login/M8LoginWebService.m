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
#if 1
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
        [M8UserDefault setLoginNick:responseData.nick];
        
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
    }];
    sigReq.identifier = identifier;
    sigReq.pwd = password;
    [[WebServiceEngine sharedEngine] AFAsynRequest:sigReq];
}

- (void)M8GetVerifyCode:(NSString *)phoneNumber succHandle:(M8LoginHandle)succHandle
{
    if (!(phoneNumber && phoneNumber.length))
    {
        [self onVerifyCodeFailAlertInfo:@"请输入手机号"];
        return ;
    }
    
    VerifyCodeRequest *verifyCodeRequest = [[VerifyCodeRequest alloc] initWithHandler:^(BaseRequest *request) {
        if (succHandle) {
            succHandle();
        }
    } failHandler:^(BaseRequest *request) {
        if (request.response.errorCode == 10003) {  // 手机号错误
            [self onVerifyCodeFailAlertInfo:@"请输入正确的手机号"];
        }
    }];
    verifyCodeRequest.phoneNumber = phoneNumber;
    [[WebServiceEngine sharedEngine] AFAsynRequest:verifyCodeRequest];
}


- (void)M8VerifyVerifyCode:(NSString *)phoneNum verifyCode:(NSString *)verifyCode succHandle:(M8LoginHandle)succHandle failHandle:(M8LoginHandle)failHandle
{
    VerifyVerifyCodeRequest *verifyRequest = [[VerifyVerifyCodeRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        if (succHandle) {
            succHandle();
        }
        
    } failHandler:^(BaseRequest *request) {
        if (failHandle) {
            failHandle();
        }
    }];
    verifyRequest.phoneNumber = phoneNum;
    verifyRequest.messageCode = verifyCode;
//    [[WebServiceEngine sharedEngine] asyncRequest:verifyRequest];
    [[WebServiceEngine sharedEngine] AFAsynRequest:verifyRequest];
}

- (void)M8RegistWithIdentifier:(NSString *)identifier nick:(NSString *)nick pwd:(NSString *)pwd cancelHandle:(M8LoginHandle)cancelHandle {
    RegistRequest *registReq = [[RegistRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        // 注册成功 -- 直接登录
        [self M8LoginWithIdentifier:identifier password:pwd cancelPVN:cancelHandle];
        
    } failHandler:^(BaseRequest *request) {
        
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        [self onRegistFailAlertInfo:errinfo];
    }];
    registReq.nick = nick;
    registReq.identifier = identifier;
    registReq.pwd = pwd;
//    [[WebServiceEngine sharedEngine] asyncRequest:registReq];
    [[WebServiceEngine sharedEngine] AFAsynRequest:registReq];
}
#endif

#if 0
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
    }];
    sigReq.identifier = identifier;
    sigReq.pwd = password;
    [[WebServiceEngine sharedEngine] AFAsynRequest:sigReq];
}

- (void)M8GetVerifyCode:(NSString *)phoneNumber succHandle:(M8LoginHandle)succHandle
{
    if (!(phoneNumber && phoneNumber.length))
    {
        [self onVerifyCodeFailAlertInfo:@"请输入手机号"];
        return ;
    }
    
    VerifyCodeRequest *verifyCodeRequest = [[VerifyCodeRequest alloc] initWithHandler:^(BaseRequest *request) {
        if (succHandle) {
            succHandle();
        }
    } failHandler:^(BaseRequest *request) {
        if (request.response.errorCode == 10003) {  // 手机号错误
            [self onVerifyCodeFailAlertInfo:@"请输入正确的手机号"];
        }
    }];
    verifyCodeRequest.phoneNumber = phoneNumber;
    [[WebServiceEngine sharedEngine] AFAsynRequest:VerifyCodeRequest];
}


- (void)M8VerifyVerifyCode:(NSString *)phoneNum verifyCode:(NSString *)verifyCode succHandle:(M8LoginHandle)succHandle failHandle:(M8LoginHandle)failHandle
{
    VerifyVerifyCodeRequest *verifyRequest = [[VerifyVerifyCodeRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        if (succHandle) {
            succHandle();
        }
        
    } failHandler:^(BaseRequest *request) {
        if (failHandle) {
            failHandle();
        }
    }];
    verifyRequest.phoneNumber = phoneNum;
    verifyRequest.messageCode = verifyCode;
//    [[WebServiceEngine sharedEngine] asyncRequest:verifyRequest];
    [[WebServiceEngine sharedEngine] AFAsynRequest:verifyRequest];
    
}

- (void)M8RegistWithIdentifier:(NSString *)identifier nick:(NSString *)nick pwd:(NSString *)pwd cancelHandle:(M8LoginHandle)cancelHandle {
    RegistRequest *registReq = [[RegistRequest alloc] initWithHandler:^(BaseRequest *request) {

        // 注册成功 -- 直接登录
        [self M8LoginWithIdentifier:identifier password:pwd cancelPVN:cancelHandle];
        
    } failHandler:^(BaseRequest *request) {
        
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        [self onRegistFailAlertInfo:errinfo];
    }];
    registReq.nick = nick;
    registReq.identifier = identifier;
    registReq.pwd = pwd;
//    [[WebServiceEngine sharedEngine] asyncRequest:registReq];
    [[WebServiceEngine sharedEngine] AFAsynRequest:registReq];
}
#endif


@end
