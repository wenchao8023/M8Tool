//
//  ReportRoomRequest.h
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/12/8.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "BaseRequest.h"


@class ShowRoomInfo;
@class HostLBS;

/**
 上报房间信息
 */
@interface ReportRoomRequest : BaseRequest

@property (nonatomic, copy) NSString * _Nonnull token;
@property (nonatomic, strong) ShowRoomInfo * _Nonnull room;
@property (nonatomic, strong, nullable) NSArray *members;   //上报通话模式中的参会成员

@end


@interface ReportRoomResponseData : BaseResponseData

/**
 上报房间信息成功之后，后台返回一个会议ID，用于记录这场会议内容
 在通话模式中有返回，直播模块中没返回
 */
@property (nonatomic, assign) int mid;

@end


