//
//  M8BaseFloatView+Live.m
//  M8Tool
//
//  Created by chao on 2017/7/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseFloatView+Live.h"

@implementation M8BaseFloatView (Live)

- (void)configLiveFloatView:(TCShowLiveListItem *)item isCameraOn:(BOOL)isCameraOn
{
    self.hostLabel.text = item.info.host;
    self.meetTypeLabel.text = @"·直播";
    self.effectView.hidden = isCameraOn;
}

- (void)onLiveVideoListener:(BOOL)isOn
{
    [self.onVoiceImg setImage:[UIImage imageNamed:(isOn ? @"liveAudio_on" : @"liveAudio_off")]];
    
    self.effectView.hidden = isOn;
    self.onVoiceImg.hidden = isOn;
}


@end
