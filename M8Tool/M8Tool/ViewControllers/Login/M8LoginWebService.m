//
//  M8LoginWebService.m
//  M8Tool
//
//  Created by chao on 2017/6/30.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LoginWebService.h"

#import "M8LoginWebService+UI.h"


typedef NS_ENUM(NSInteger, loginType)
{
    loginType_onClick,      //点击登录
    loginType_reLogin,      //重新登录
    loginType_autoLogin,    //自动登录
};



@implementation M8LoginWebService

#pragma mark - -- login
//登录请求
- (void)M8LoginWithIdentifier:(NSString *)identifier
                     password:(NSString *)password
                   succHandle:(M8LoginHandle)succHandle
                   failHandle:(M8LoginHandle)failHandle
                    loginType:(loginType)type
{
    //请求sig
    LoginRequest *sigReq = [[LoginRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        LoginResponceData *responseData = (LoginResponceData *)request.response.data;
        [AppDelegate sharedAppDelegate].token = responseData.token;
        [M8UserDefault setLoginNick:responseData.nick];
        
        [[ILiveLoginManager getInstance] iLiveLogin:identifier sig:responseData.userSig succ:^{
            
            if (type == loginType_onClick ||
                type == loginType_autoLogin)
            {
                [self onLoginSucc:identifier password:password];
            }
            
            // 登录成功
            if (succHandle)
            {
                succHandle();
            }
            
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            
            if (errId == 8050)//离线被踢,再次登录
            {
                [self M8LoginWithIdentifier:identifier
                                   password:password
                                 succHandle:succHandle
                                 failHandle:failHandle
                                  loginType:type
                 ];
            }
            else if (type == loginType_onClick ||
                     type == loginType_reLogin)
            {
                NSString *errInfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
                [self onLoginFailAlertInfo:errInfo];
            }
            
            if (failHandle)
            {
                failHandle();
            }
        }];
        
    } failHandler:^(BaseRequest *request) {
        
        if (type == loginType_onClick ||
            type == loginType_reLogin)
        {
            NSString *errInfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode, request.response.errorInfo];
            [self onLoginFailAlertInfo:errInfo];
        }
        
        
        if (failHandle)
        {
            failHandle();
        }
    }];
    
    sigReq.identifier = identifier;
    sigReq.pwd = password;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:sigReq];
}

//登录界面登录
- (void)M8LoginWithIdentifier:(NSString *)identifier
                     password:(NSString *)password
                    cancelPVN:(M8LoginHandle _Nullable)cancelHandle
{
    [self M8LoginWithIdentifier:identifier
                       password:password
                      succHandle:cancelHandle
                     failHandle:cancelHandle
                      loginType:loginType_onClick
     ];
}

//被踢下线重新登录
- (void)M8ReLoginWithIdentifier:(NSString *)identifier
                     password:(NSString *)password
                    cancelPVN:(M8LoginHandle _Nullable)cancelHandle
{
    [self M8LoginWithIdentifier:identifier
                       password:password
                     succHandle:cancelHandle
                     failHandle:cancelHandle
                      loginType:loginType_reLogin
     ];
}

//启动App 自动登录
- (void)M8AutoLoginWithIdentifier:(NSString *)identifier
                         password:(NSString *)password
                       failHandle:(M8LoginHandle)failHandle
{
    [self M8LoginWithIdentifier:identifier
                       password:password
                     succHandle:nil
                     failHandle:failHandle
                      loginType:loginType_autoLogin
     ];
}


- (void)M8LoginToGetSigWithIdentifier:(NSString *)identifier
                             password:(NSString *)password
{
    //请求sig
    LoginRequest *sigReq = [[LoginRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        LoginResponceData *responseData = (LoginResponceData *)request.response.data;
        [AppDelegate sharedAppDelegate].token = responseData.token;
        [M8UserDefault setLoginNick:responseData.nick];
        
        [[ILiveLoginManager getInstance] iLiveLogin:identifier sig:responseData.userSig succ:^{
            

        } failed:^(NSString *module, int errId, NSString *errMsg) {
            
            if (errId == 8050)//离线被踢,再次登录
            {
                [self M8LoginToGetSigWithIdentifier:identifier password:password];
            }
        }];
        
    } failHandler:^(BaseRequest *request) {

    }];
    
    sigReq.identifier = identifier;
    sigReq.pwd = password;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:sigReq];
}


//QQ登录
- (void)M8QQLoginWithOpenId:(NSString *)openId
                       nick:(NSString *)nick
                 succHandle:(M8LoginHandle)succHandle
                 failHandle:(M8LoginHandle)failHandle
                  loginType:(loginType)type
{
    QQLoginRequest *qqLoginReq = [[QQLoginRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        LoginResponceData *responseData = (LoginResponceData *)request.response.data;
        [AppDelegate sharedAppDelegate].token = responseData.token;
        [M8UserDefault setLoginNick:responseData.nick];

        [[ILiveLoginManager getInstance] iLiveLogin:openId sig:responseData.userSig succ:^{
            
            if (type == loginType_onClick ||
                type == loginType_autoLogin)
            {
                [self onQQLoginSucc:openId];
            }
            
            // 登录成功
            if (succHandle)
            {
                succHandle();
            }
        } failed:^(NSString *module, int errId, NSString *errMsg) {
          
            if (errId == 8050)//离线被踢,再次登录
            {
                [self M8QQLoginWithOpenId:openId
                                     nick:nick
                               succHandle:succHandle
                               failHandle:failHandle
                                loginType:type
                 ];
            }
            else if (type == loginType_onClick ||
                     type == loginType_reLogin)
            {
                NSString *errInfo = [NSString stringWithFormat:@"module=%@,errid=%d,errmsg=%@",module,errId,errMsg];
                [self onLoginFailAlertInfo:errInfo];
            }
            
            if (failHandle)
            {
                failHandle();
            }

        }];        
    } failHandler:^(BaseRequest *request) {
        
        if (type == loginType_onClick ||
            type == loginType_reLogin)
        {
            NSString *errInfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode, request.response.errorInfo];
            [self onLoginFailAlertInfo:errInfo];
        }
        
        
        if (failHandle)
        {
            failHandle();
        }
    }];
    
    qqLoginReq.openId = openId;
    qqLoginReq.nick   = nick;
    qqLoginReq.appId  = ILiveAppId;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:qqLoginReq];
}

//登录界面登录
- (void)M8QQLoginWithOpenId:(NSString *)openId
                       nick:(NSString *)nick
                    cancelPVN:(M8LoginHandle _Nullable)cancelHandle
{
    [self M8QQLoginWithOpenId:openId
                         nick:nick
                   succHandle:cancelHandle
                   failHandle:cancelHandle
                    loginType:loginType_onClick
     ];
}

//被踢下线重新登录
- (void)M8QQReLoginWithOpenId:(NSString *)openId
                         nick:(NSString *)nick
                      cancelPVN:(M8LoginHandle _Nullable)cancelHandle
{
    [self M8QQLoginWithOpenId:openId
                         nick:nick
                   succHandle:cancelHandle
                   failHandle:cancelHandle
                    loginType:loginType_reLogin
     ];
}

//启动App 自动登录
- (void)M8QQAutoLoginWithOpenId:(NSString *)openId
                           nick:(NSString *)nick
                       failHandle:(M8LoginHandle)failHandle
{
    [self M8QQLoginWithOpenId:openId
                         nick:nick
                   succHandle:failHandle
                   failHandle:failHandle
                    loginType:loginType_autoLogin
     ];
}




#pragma mark - -- verifyCode
- (void)M8GetVerifyCode:(NSString *)phoneNumber
             succHandle:(M8LoginHandle)succHandle
{
    if (!(phoneNumber && phoneNumber.length))
    {
        [self onVerifyCodeFailAlertInfo:@"请输入手机号"];
        return ;
    }
    
    if (![phoneNumber validateMobile])
    {
        [self onVerifyCodeFailAlertInfo:@"请输入正确的手机号"];
        return ;
    }
    
    VerifyCodeRequest *verifyCodeRequest = [[VerifyCodeRequest alloc] initWithHandler:^(BaseRequest *request) {
        if (succHandle) {
            succHandle();
        }
    } failHandler:^(BaseRequest *request) {
        
        [self onVerifyCodeFailAlertInfo:@"获取验证码失败"];
        
        if (request.response.errorCode == 10003)
        {  // 手机号错误
            [self onVerifyCodeFailAlertInfo:@"请输入正确的手机号"];
        }
    }];
    
    verifyCodeRequest.phoneNumber = phoneNumber;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:verifyCodeRequest];
}


- (void)M8VerifyVerifyCode:(NSString *)phoneNum
                verifyCode:(NSString *)verifyCode
                succHandle:(M8LoginHandle)succHandle
                failHandle:(M8LoginHandle)failHandle
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
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:verifyRequest];
}

- (void)M8RegistWithIdentifier:(NSString *)identifier
                          nick:(NSString *)nick
                           pwd:(NSString *)pwd
                        veriCode:(NSString *_Nonnull)veriCode
                  cancelHandle:(M8LoginHandle)cancelHandle
{
    RegistRequest *registReq = [[RegistRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        // 注册成功 -- 直接登录
        [self M8LoginWithIdentifier:identifier password:pwd cancelPVN:cancelHandle];
        
    } failHandler:^(BaseRequest *request) {
        
        if (cancelHandle)
        {
            cancelHandle();
        }
        
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        [self onRegistFailAlertInfo:errinfo];
        
        if (request.response.errorCode == 10004)
        {
            [self onRegistFailAlertInfo:@"该用户已存在"];
        }
    }];
    
    registReq.nick          = nick;
    registReq.identifier    = identifier;
    registReq.pwd           = pwd;
    registReq.messageCode   = veriCode;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:registReq];
}

- (void)m8ResetPwdWithPhoneNumber:(NSString *)phoneNumber
                              pwd:(NSString *)pwd
                         veriCode:(NSString *)veriCode
                     cancelHandle:(M8LoginHandle)cancelHandle
{
    
    ModifyPwdWithPhoneRequest *resetPwdReq = [[ModifyPwdWithPhoneRequest alloc] initWithHandler:^(BaseRequest *request) {
    
        // 修改密码成功 -- 直接登录
        [self M8LoginWithIdentifier:phoneNumber password:pwd cancelPVN:cancelHandle];
        
        
    } failHandler:^(BaseRequest *request) {
        
        NSString *errinfo = [NSString stringWithFormat:@"errid=%ld,errmsg=%@",(long)request.response.errorCode,request.response.errorInfo];
        [self onResetPwdAlertInfo:errinfo];
    }];
    
    resetPwdReq.phoneNumber = phoneNumber;
    resetPwdReq.pwd         = pwd;
    resetPwdReq.messageCode = veriCode;
    
    [[WebServiceEngine sharedEngine] AFAsynRequest:resetPwdReq];
}
@end
