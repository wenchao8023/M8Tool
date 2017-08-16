//
//  MeetCollectRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 会议收藏请求
 */
@interface MeetCollectRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, assign) int mid;  //会议ID

@end
