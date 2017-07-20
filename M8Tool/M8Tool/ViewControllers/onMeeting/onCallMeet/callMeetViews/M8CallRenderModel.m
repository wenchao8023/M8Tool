//
//  M8CallRenderModel.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderModel.h"

@implementation M8CallRenderModel

- (instancetype)init
{
    if (self = [super init])
    {
        _meetMemberStatus = MeetMemberStatus_none;
        _isCameraOn     = NO;
        _isMicOn        = NO;
        _videoScrType   = QAVVIDEO_SRC_TYPE_CAMERA;
        _userActionDuration  = 0;
    }
    return self;
}


- (void)onUserActionBegin
{
    self.isInUserAction = YES;
    self.userActionDuration = 10;
    self.userActionTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countCancelTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.userActionTimer forMode:NSDefaultRunLoopMode];
    [self.userActionTimer fire];
}

- (void)countCancelTimer
{
    self.userActionDuration -= 1;
    if (self.userActionDuration == 0 ||
        self.isInUserAction == NO)
    {
        if ([self.userActionTimer isValid])
        {
            [self.userActionTimer invalidate];
            self.userActionTimer = nil;
        }
        
        if (self.userActionEndAutom)
        {
            self.userActionEndAutom();
        }
    }
}

- (void)onUserActionEnd
{
    self.isInUserAction = NO;
    if ([self.userActionTimer isValid])
    {
        [self.userActionTimer invalidate];
        self.userActionTimer = nil;
    }
}

@end
