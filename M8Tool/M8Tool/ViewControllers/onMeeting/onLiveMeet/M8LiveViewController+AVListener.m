//
//  M8LiveViewController+AVListener.m
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveViewController+AVListener.h"

@implementation M8LiveViewController (AVListener)

#pragma mark - ILVLiveAVListener
/**
 * 音视频事件回调
 * @param  event   事件
 * @param  users   用户endpoints ,QAVEndpoint
 */
- (void)onUserUpdateInfo:(ILVLiveAVEvent)event users:(NSArray *)users
{
    
}

/**
 * 首帧到达回调
 * @param width       宽度
 * @param height      高度
 * @param identifier  id
 * @param srcType     视频源类型
 */
- (void)onFirstFrameRecved:(int)width height:(int)height identifier:(NSString *)identifier srcType:(avVideoSrcType)srcType
{
    
}

/**
 * SDK主动退出房间提示。该回调方法表示SDK内部主动退出了房间。SDK内部会因为30s心跳包超时等原因主动退出房间，APP需要监听此退出房间事件并对该事件进行相应处理
 * @param reason 退出房间的原因，具体值见返回码
 */
- (void)onRoomDisconnect:(int)reason
{
    
}




#pragma mark - QAVLocalVideoDelegate

/*!
 @abstract      本地画面预览回调
 @param         frameData       本地视频帧数据
 @see           QAVVideoFrame
 */
- (void)OnLocalVideoPreview:(QAVVideoFrame *)frameData
{
    
}

/*!
 @abstract      本地画面预处理视频回调，修改了data的数据后会在编码后传给服务器。
 @param         frameData       本地视频帧数据
 @see           QAVVideoFrame
 */
- (void)OnLocalVideoPreProcess:(QAVVideoFrame *)frameData
{
    
}

/*!
 @abstract      摄像头返回的本地画面原始数据
 @param         buf             本地视频帧原始数据
 @param         ret             本地视频帧原始数据
 */
- (void)OnLocalVideoRawSampleBuf:(CMSampleBufferRef)buf result:(CMSampleBufferRef *)ret
{
    
}


@end
