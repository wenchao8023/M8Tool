//
//  M8MeetRenderModel.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRenderModel.h"

@implementation M8MeetRenderModel

- (instancetype)init {
    if (self = [super init]) {
        _videoScrType = QAVVIDEO_SRC_TYPE_NONE;
        _isCameraOn   = NO;
        _isMicOn      = NO;
        _isEnterRoom  = NO;
        _isLeaveRoom  = NO;
        _isInBack     = NO;
    }
    return self;
}

@end
