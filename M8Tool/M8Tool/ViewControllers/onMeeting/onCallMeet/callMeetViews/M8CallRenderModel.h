//
//  M8CallRenderModel.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, onMeetMemberStatus)
{
    MeetMemberStatus_none       = 0,   ///< 默认值，表示等待用户接听
    MeetMemberStatus_linebusy   = 1,   ///< 用户忙
    MeetMemberStatus_reject     = 2,   ///< 用户已拒绝
    MeetMemberStatus_timeout    = 3,   ///< 用户呼叫超时
    MeetMemberStatus_receive    = 4,   ///< 用户接受
    MeetMemberStatus_hangup     = 5,   ///< 用户挂断
    MeetMemberStatus_disconnect = 6    ///< 用户断开连接
};

@interface M8CallRenderModel : NSObject

/**
 成员id  只记录一次
 成员唯一标识符
 */
@property (nonatomic, copy, nullable) NSString *identify;

/**
 成员Nick，用于显示在 renderView 里面
 */
@property (nonatomic, copy, nullable) NSString *nick;

/**
 用户状态
 */
@property (nonatomic, assign) onMeetMemberStatus meetMemberStatus;

/**
 摄像头是否打开
 */
@property (nonatomic, assign) BOOL isCameraOn;

/**
 麦克风是否打开
 */
@property (nonatomic, assign) BOOL isMicOn;

/**
 视频源类型
 */
@property (nonatomic, assign) avVideoSrcType videoScrType;


/**
 判断用户是不是在操作不在房间的成员
 */
@property (nonatomic, assign) BOOL isInUserAction;

/**
 用于记录用户点击不在房间中的成员之后唤起的 移除 和 邀请按钮
 */
@property (nonatomic, strong, nullable) NSTimer *userActionTimer;

/**
 默认是0，点击之后设置为10s
 当从10到0之间用户没有继续操作这两个，就将还原状态
 */
@property (nonatomic, assign) NSInteger userActionDuration;

- (void)onUserActionBegin;
- (void)onUserActionEnd;
@property (nonatomic, copy, nullable) TCIVoidBlock userActionEndAutom;



@end
