//
//  M8CallRenderModel.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderModel.h"

@implementation M8CallRenderModel

- (instancetype)init {
    if (self = [super init]) {
        _meetMemberStatus = MeetMemberStatus_none;
        _isCameraOn     = NO;
        _isMicOn        = NO;
        _videoScrType = QAVVIDEO_SRC_TYPE_CAMERA;
    }
    return self;
}


@end
