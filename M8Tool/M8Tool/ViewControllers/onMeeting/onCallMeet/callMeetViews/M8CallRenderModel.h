//
//  M8CallRenderModel.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, onMeetMemberStatus) {
    MeetMemberStatus_none       = 0,   ///< 默认值，无意义
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



///**
// 是否是用户忙
// */
//@property (nonatomic, assign) BOOL isLineBusy;
///**
// 是否是主动拒绝
// */
//@property (nonatomic, assign) BOOL isCallReject;
//
///**
// 是否是呼叫超时
// */
//@property (nonatomic, assign) BOOL isCallTimeout;
//
///**
// 成员是否进入房间  只记录一次
// */
//@property (nonatomic, assign) BOOL isEnterRoom;
//
///**
// 成员失去连接（可能是网络原因）
// */
//@property (nonatomic, assign) BOOL isDisconnect;
//
///**
// 是否离开房间 可以有多次
// * 一次也没调用，表示成员重来没有离开过房间
// * 调用基数次，成员离开房间， 设为 YES
// * 调用偶数次，成员离开房间后又进入， 设为 NO
// */
//@property (nonatomic, assign) BOOL isLeaveRoom;


@end
