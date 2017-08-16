//
//  ModifyPwdRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface ModifyPwdRequest : BaseRequest

@end


/**
 通过旧密码修改密码
 */
@interface ModifyPwdWithOldPwdRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, copy, nullable) NSString *oldpwd;
@property (nonatomic, copy, nullable) NSString *pwd;

@end



/**
 通过手机号验证修改密码(注意要通过手机验证码之后才能修改)
 */
@interface ModifyPwdWithPhoneRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *phoneNumber;    //手机号
@property (nonatomic, copy, nullable) NSString *pwd;            //密码
@property (nonatomic, copy, nullable) NSString *messageCode;    //验证码

@end
