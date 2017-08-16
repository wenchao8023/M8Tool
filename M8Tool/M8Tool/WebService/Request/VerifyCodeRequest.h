//
//  VerifyCodeRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/3.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 发送验证码
 */
@interface VerifyCodeRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *phoneNumber;

@end
