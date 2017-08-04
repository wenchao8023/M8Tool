//
//  M8BaseFloatView+Call.m
//  M8Tool
//
//  Created by chao on 2017/7/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8BaseFloatView+Call.h"

@implementation M8BaseFloatView (Call)

- (void)configCallFloatView:(NSString *)hostNick callType:(TILCallType)callType cameraOn:(BOOL)isCameraOn
{
    self.hostLabel.text = hostNick;
    self.meetTypeLabel.text = (callType == TILCALL_TYPE_VIDEO) ? @"·视频" : @"·语音";
    self.effectView.hidden = isCameraOn;
}

//- (void)configCallFloatView:(TCShowLiveListItem *)item isCameraOn:(BOOL)isCameraOn
//{
//    self.hostLabel.text = item.info.host;
//    self.meetTypeLabel.text = (item.callType == TILCALL_TYPE_VIDEO) ? @"·视频" : @"·语音";
//    
//    self.effectView.hidden = isCameraOn;
//}

- (void)onCallVideoListener:(BOOL)isOn
{
    [self.onVoiceImg setImage:[UIImage imageNamed:(isOn ? @"liveAudio_on" : @"liveAudio_off")]];
    
    self.effectView.hidden = isOn;
    self.onVoiceImg.hidden = isOn;
}

@end
