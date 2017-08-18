//
//  SendNotifyRequest.h
//  M8Tool
//
//  Created by chao on 2017/8/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface SendNotifyRequest : BaseRequest

@end

/**
 *
	"token"  :[token],
	"toUser":["user1","user2"],
	"type":11,
	"inviter":"邀请人",
	"topic":"会议主题"
 */

@interface SendCallNotifyRequest : BaseRequest

@property (nonatomic, assign          ) int      type;
@property (nonatomic, assign          ) int      topic;
@property (nonatomic, copy, nullable  ) NSString *token;
@property (nonatomic, copy, nullable  ) NSString *inviter;
@property (nonatomic, strong, nullable) NSArray  *toUser;

@end
