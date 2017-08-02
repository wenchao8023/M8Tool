//
//  LoginRequest.h
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/11/30.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginRequest : BaseRequest

@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic, copy) NSString * _Nullable pwd;

@end

@interface LoginResponceData : BaseResponseData

@property (nonatomic, copy) NSString * _Nullable userSig;
@property (nonatomic, copy) NSString * _Nullable token;
@property (nonatomic, copy, nullable) NSString *nick;

@end

@interface QQLoginRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *openId;
@property (nonatomic, copy, nullable) NSString *nick;
@property (nonatomic, copy, nullable) NSString *appId;

@end




