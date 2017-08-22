//
//  PartDetailRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 部门中的成员信息
 */
@interface PartDetailRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, assign) int did;

@end


@interface PartDetailResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSArray *members;           //部门中成员
@property (nonatomic, strong, nullable) NSDictionary *department;   //部门信息

@end
