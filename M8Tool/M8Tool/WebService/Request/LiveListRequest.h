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

@property (nonatomic, copy, nullable) NSString *total; //会议总数
@property (nonatomic, strong, nullable) NSArray *rooms;

@end


@class M8LiveRoomInfo;

@interface M8LiveRoomModel : NSObject

@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, strong, nullable) M8LiveRoomInfo *info;

@end


@interface M8LiveRoomInfo : NSObject

@property (nonatomic, copy, nullable) NSString *roomnum;
@property (nonatomic, copy, nullable) NSString *groupid;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, copy, nullable) NSString *cover;
@property (nonatomic, copy, nullable) NSString *thumbup;
@property (nonatomic, copy, nullable) NSString *memsize;

@end
