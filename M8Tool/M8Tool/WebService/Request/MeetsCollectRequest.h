//
//  MeetsCollectRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 会议收藏列表
 */
@interface MeetsCollectRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger nums;

@end

