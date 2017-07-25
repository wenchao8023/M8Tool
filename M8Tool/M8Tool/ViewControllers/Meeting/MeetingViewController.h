//
//  MeetingViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"

#import "MeetingButtonsCollection.h"

@interface MeetingViewController : BaseViewController

@property (nonatomic, strong, nullable) MeetingButtonsCollection   *buttonsCollection;

/**
 语音听写按钮
 */
@property (nonatomic, strong, nullable) UIButton *speechBtn;

//不带界面的识别对象
@property (nonatomic, strong, nullable) IFlySpeechRecognizer *iFlySpeechRecognizer;

@end
