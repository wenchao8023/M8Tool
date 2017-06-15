//
//  M8CallAudioDevice.m
//  M8Tool
//
//  Created by chao on 2017/6/10.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallAudioDevice.h"

@interface M8CallAudioDevice ()

{
    CGRect _myFrame;
}

/**
 分享（分享类似一个二维码，扫码可进入直播间）
 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

/**
 关闭麦克风
 */
@property (weak, nonatomic) IBOutlet UIButton *closeMicButton;

/**
 挂断
 */
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;


/**
 免提
 */
@property (weak, nonatomic) IBOutlet UIButton *switchReceiverButton;

/**
 文本输入
 */
@property (weak, nonatomic) IBOutlet UIButton *noteButton;


@end


@implementation M8CallAudioDevice

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}

- (void)configButtonBackImgs {
    
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    
    BOOL micState = [manager getCurMicState];
    [self.closeMicButton setBackgroundImage:[UIImage imageNamed:(!micState? @"liveMic_off" : @"liveMic_on")]
                                   forState:UIControlStateNormal];
    
    QAVOutputMode audioMode = [manager getCurAudioMode];
    [self.switchReceiverButton setBackgroundImage:[UIImage imageNamed:(audioMode == QAVOUTPUTMODE_EARPHONE ? @"liveReceiver_off" : @"liveReceiver_on")]
                                         forState:UIControlStateNormal];
}


#pragma mark device actions
- (IBAction)onShareAction:(id)sender {
    [self deviceActionInfoValue:@"onShareAction" key:kCallAudioDeviceAction];
}

- (IBAction)onCloseMicAction:(id)sender {
    [self deviceActionInfoValue:@"onCloseMicAction" key:kCallAudioDeviceAction];
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    NSString *text = isOn ? @"关闭麦克风成功" : @"打开麦克风成功";
    WCWeakSelf(self);
    
    [manager enableMic:!isOn succ:^{
        [weakself deviceActionInfoValue:text key:kCallAudioDeviceText];
        [weakself.closeMicButton setBackgroundImage:[UIImage imageNamed:(!isOn? @"liveMic_on" : @"liveMic_off")]
                                           forState:UIControlStateNormal];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [weakself deviceActionInfoValue:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg] key:kCallAudioDeviceText];
    }];
}

- (IBAction)onHangupAction:(id)sender {
    [self deviceActionInfoValue:@"onHangupAction" key:kCallAudioDeviceAction];
}

- (IBAction)onSwitchReceiverAction:(id)sender {
    [self deviceActionInfoValue:@"onSwitchReceiverAction" key:kCallAudioDeviceAction];
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    QAVOutputMode mode = [manager getCurAudioMode];
    
    
    if(mode == QAVOUTPUTMODE_EARPHONE){
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
        [self deviceActionInfoValue:@"切换扬声器成功" key:kCallAudioDeviceText];
        [self.switchReceiverButton setBackgroundImage:kGetImage(@"liveReceiver_on") forState:UIControlStateNormal];
    }
    else{
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
        [self deviceActionInfoValue:@"切换听筒成功" key:kCallAudioDeviceText];
        [self.switchReceiverButton setBackgroundImage:kGetImage(@"liveReceiver_off") forState:UIControlStateNormal];
    }
}

- (IBAction)onNoteAction:(id)sender {
    [self deviceActionInfoValue:@"onNoteAction" key:kCallAudioDeviceAction];
}

#pragma mark - MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(CallAudioDeviceActionInfo:)]) {
        [self.WCDelegate CallAudioDeviceActionInfo:actionInfo];
    }
}


@end