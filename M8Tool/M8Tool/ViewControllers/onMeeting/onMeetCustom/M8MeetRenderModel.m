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
        _meetMemberStatus = MeetMemberStatus_none;
        _isCameraOn     = NO;
        _isMicOn        = NO;
        _videoScrType = QAVVIDEO_SRC_TYPE_CAMERA;
    }
    return self;
}


@end
