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
    NSString *host = self.liveItem.info.host;
    
    TILLiveManager *manager = [TILLiveManager getInstance];
    switch(event) {
        case ILVLIVE_AVEVENT_MEMBER_ENTER:
        {
            
        }
        case ILVLIVE_AVEVENT_MEMBER_EXIT:
        {
            
        }
        case ILVLIVE_AVEVENT_CAMERA_ON:
        {
            //视频事件
            for (NSString *user in users) {
                if(![user isEqualToString:host]){
                    [manager addAVRenderView:[self getRenderFrame:self.identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                    [self.identifierArray addObject:user];
                    [self.srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_CAMERA)];
                }
                else{
                    [manager addAVRenderView:self.view.bounds forIdentifier:host srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                }
            }
        }
            break;
        case ILVLIVE_AVEVENT_CAMERA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:host]){
                    NSInteger index = [self.identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                    [self.identifierArray removeObjectAtIndex:index];
                    [self.srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
            break;
        case ILVLIVE_AVEVENT_SCREEN_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:host]){
                    [manager addAVRenderView:[self getRenderFrame:self.identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
                    [self.identifierArray addObject:user];
                    [self.srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_SCREEN)];
                }
                else{
                }
            }
        }
            break;
        case ILVLIVE_AVEVENT_SCREEN_OFF:
        {
            for (NSString *user in users)
            {
                if(![user isEqualToString:host])
                {
                    NSInteger index = [self.identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_SCREEN];
                    [self.identifierArray removeObjectAtIndex:index];
                    [self.srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        case ILVLIVE_AVEVENT_MEDIA_ON:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:host]){
                    [manager addAVRenderView:[self getRenderFrame:self.identifierArray.count] forIdentifier:user srcType:QAVVIDEO_SRC_TYPE_MEDIA];
                    [self.identifierArray addObject:user];
                    [self.srcTypeArray addObject:@(QAVVIDEO_SRC_TYPE_MEDIA)];
                }
                else{
                }
            }
        }
            break;
        case ILVLIVE_AVEVENT_MEDIA_OFF:
        {
            for (NSString *user in users) {
                if(![user isEqualToString:host]){
                    NSInteger index = [self.identifierArray indexOfObject:user];
                    [manager removeAVRenderView:user srcType:QAVVIDEO_SRC_TYPE_MEDIA];
                    [self.identifierArray removeObjectAtIndex:index];
                    [self.srcTypeArray removeObjectAtIndex:index];
                }
                else{
                }
                [self updateRenderFrame];
            }
        }
        default:
            break;
    }
}

- (CGRect)getRenderFrame:(NSInteger)count{
    if(count == 3){
        return CGRectZero;
    }
    CGFloat height = (self.view.height - 2*20 - 3 * 10)/3;
    CGFloat width = height*3/4;//宽高比3:4
    CGFloat y = 20 + (count * (height + 10));
    CGFloat x = 20;
    return CGRectMake(x, y, width, height);
}

- (void)updateRenderFrame{
    TILLiveManager *manager = [TILLiveManager getInstance];
    for(NSInteger index = 0; index < self.identifierArray.count; index++){
        CGRect frame = [self getRenderFrame:index];
        NSString *identifier = self.identifierArray[index];
        avVideoSrcType srcType = [self.srcTypeArray[index] intValue];
        [manager modifyAVRenderView:frame forIdentifier:identifier srcType:srcType];
    }
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
