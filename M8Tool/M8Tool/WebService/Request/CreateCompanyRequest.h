//
//  CreateCompanyRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 创建公司请求
 */
@interface CreateCompanyRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, copy, nullable) NSString *name;   //公司名


@end

@interface CreateCompanyResponseData : BaseResponseData

@property (nonatomic, copy, nullable) NSString *cid;    //公司ID

@end
