//
//  VerifyVerifyCodeRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/3.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface VerifyVerifyCodeRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *phoneNumber;
@property (nonatomic, copy, nullable) NSString *messageCode;
@end
