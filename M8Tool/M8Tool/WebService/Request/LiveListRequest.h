//
//  LiveListRequest.h
//  M8Tool
//
//  Created by looper on 17/7/22.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface LiveListRequest : BaseRequest


@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic,assign ) NSInteger appid;

@end


@interface LiveListResponseData : BaseResponseData

@property (nonatomic, strong, nullable) NSArray *livesArr;

@end
