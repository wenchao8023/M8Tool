//
//  MeetsListRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 获取会议列表
 */
@interface MeetsListRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger nums;

@end


@interface MeetsListResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSArray *meetsArray;

@end
