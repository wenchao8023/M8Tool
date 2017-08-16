//
//  CallRoomRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface CallRoomRequest : BaseRequest

@property (nonatomic, copy) NSString *token;


@end

@interface CallRoomResponseData : BaseResponseData

@property (nonatomic, copy) NSString *callId;

@end
