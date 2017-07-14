//
//  RecentlyContactRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface RecentlyContactRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;

@end


@interface RecentlyContactResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSArray *nearusers;

@end
