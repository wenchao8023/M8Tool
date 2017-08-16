//
//  CompanyListRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 创建公司
 */
@interface CompanyListRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;

@end


@interface CompanyListResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSArray *companys;

@end


/**
 获取公司详情
 */
@interface CompanyDetailRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, assign) int cId;

@end


@interface CompanyDetailResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSDictionary *companyinfo;

@end
