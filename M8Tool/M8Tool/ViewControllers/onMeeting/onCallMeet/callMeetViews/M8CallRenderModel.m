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
//    self.userActionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countCancelTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.userActionTimer forMode:NSRunLoopCommonModes];
    [self.userActionTimer fire];
}

- (void)countCancelTimer
{
    WCLog(@"剩余操作时间 : %ld", (long)self.userActionDuration);
    
    if (self.isInUserAction == YES)
    {
        if (self.userActionDuration == 0)
        {
            [self onUserActionEnd];
            
            if (self.userActionEndAutom)
            {
                self.userActionEndAutom(self);
            }
        }
        else
        {
            self.userActionDuration -= 1;
        }
    }
    else
    {
        [self onUserActionEnd];
    }
}

- (void)onUserActionEnd
{
    if (!self.userActionTimer)
    {
        //防止在主线程里面执行该方法
        [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(countCancelTimer) target:self argument:nil];
    }
    self.isInUserAction = NO;
    self.userActionDuration = 0;
    if ([self.userActionTimer isValid])
    {
        [self.userActionTimer invalidate];
        self.userActionTimer = nil;
    }
}

@end
