//
//  FriendsListRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface FriendsListRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *identifier;
@property (nonatomic, copy, nullable) NSString *token;

@end



@interface FriendsListResponceData : BaseResponseData

/**
 时间戳
 */
@property (nonatomic, assign) long TimeStampNow;

/**
 开始请求的下标
 */
@property (nonatomic, assign) long StartIndex;

/**
 当前请求数目
 */
@property (nonatomic, assign) long CurrentStandardSequence;

/**
 好友数目
 */
@property (nonatomic, assign) long FriendNum;

/**
 错误码
 */
@property (nonatomic, assign) long ErrorCode;


/**
 是否需要更新所有的
 Value :  "GetAll_Type_NO" -- 表示不需要更新所有列表
 */
@property (nonatomic, copy, nullable) NSString *NeedUpdateAll;

/**
 事件状态
 Value : "OK" -- 表示正确
 */
@property (nonatomic, copy, nullable) NSString *ActionStatus;

/**
 错误信息
 */
@property (nonatomic, copy, nullable) NSString *ErrorInfo;
@property (nonatomic, copy, nullable) NSString *ErrorDisplay;


/**
 成员列表
 */
@property (nonatomic, strong, nullable) NSArray *InfoItem;

@end
