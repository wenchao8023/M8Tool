//
//  M8MeetRenderModel.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8MeetRenderModel : NSObject

/**
 成员id
 */
@property (nonatomic, copy, nullable) NSString *identify;

/**
 成员是否显示在背景视图
 */
@property (nonatomic, assign) BOOL isInBack;

/**
 视频源类型
 */
@property (nonatomic, assign) avVideoSrcType videoScrType;

/**
 摄像头是否打开
 */
@property (nonatomic, assign) BOOL isCameraOn;

/**
 麦克风是否打开
 */
@property (nonatomic, assign) BOOL isMicOn;

/**
 是否接收并进入房间
 */
@property (nonatomic, assign) BOOL isEnterRoom;

/**
 是否离开房间
 */
@property (nonatomic, assign) BOOL isLeaveRoom;



@end
