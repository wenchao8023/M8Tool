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

@property (nonatomic, strong, nonnull) NSArray *members;

@end
