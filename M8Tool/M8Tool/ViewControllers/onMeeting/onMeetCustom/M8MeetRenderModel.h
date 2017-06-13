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
 成员id  只记录一次
 成员唯一标识符
 */
@property (nonatomic, copy, nullable) NSString *identify;

/**
 成员是否进入房间  只记录一次
 */
@property (nonatomic, assign) BOOL isEnterRoom;

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
 是否离开房间 可以有多次
    * 一次也没调用，表示成员重来没有离开过房间
    * 调用基数次，成员离开房间， 设为 YES
    * 调用偶数次，成员离开房间后又进入， 设为 NO
 */
@property (nonatomic, assign) BOOL isLeaveRoom;






@end
