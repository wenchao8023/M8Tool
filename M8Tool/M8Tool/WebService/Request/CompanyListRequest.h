//
//  CompanyListRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface CompanyListRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;

@end


@interface CompanyListResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSArray *companys;

@end
