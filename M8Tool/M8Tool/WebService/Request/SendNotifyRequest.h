//
//  SendNotifyRequest.h
//  M8Tool
//
//  Created by chao on 2017/8/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"


/**
 *  发起通话时的通知类型
 */
typedef NS_ENUM(NSInteger, M8RemoteNotificationType)
{
    M8RemoteNotificationType_MAKECALL = 0x0001,//发起音视频的通知
};



@interface SendNotifyRequest : BaseRequest

@end




/**
 *  发起电话邀请时创建推送
 */
@interface MakeCallNotifyRequest : BaseRequest

@property (nonatomic, assign          ) M8RemoteNotificationType notifyType;//通知类型
@property (nonatomic, assign          ) int                      callType;//会议类型(0-视频会议，1-音频会议)
@property (nonatomic, copy, nullable  ) NSString                 *token;
@property (nonatomic, copy, nullable  ) NSString                 *inviter;//会议邀请人
@property (nonatomic, strong, nullable) NSArray                  *toUser;//被邀请的成员

@end
