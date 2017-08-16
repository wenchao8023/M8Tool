//
//  MeetingViewController+IFlyMSC.h
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingViewController.h"

/**
 语音听写demo
     1.创建识别对象；
     2.设置识别参数；
     3.有选择的实现识别回调；
     4.启动识别
 */
@interface MeetingViewController (IFlyMSC)<IFlySpeechRecognizerDelegate>

- (void)onSpeechAction;

@end
