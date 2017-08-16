//
//  JoinPartRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 加入部门请求
 */
@interface JoinPartRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, assign) int did;  //部门ID
@property (nonatomic, strong, nonnull) NSArray *uid;

@end
