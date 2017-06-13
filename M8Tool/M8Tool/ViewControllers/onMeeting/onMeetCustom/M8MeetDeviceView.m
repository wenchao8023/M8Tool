//
//  M8MeetDeviceView.m
//  M8Tool
//
//  Created by chao on 2017/6/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetDeviceView.h"


@interface M8MeetDeviceView ()
{
    CGRect _myFrame;
}

/**
 分享（分享类似一个二维码，扫码可进入直播间）
 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

/**
 切换摄像头
 */
@property (weak, nonatomic) IBOutlet UIButton *swichCameraButton;

/**
 关闭摄像头
 */
@property (weak, nonatomic) IBOutlet UIButton *closeCameraButton;

/**
 挂断
 */
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;

/**
 关闭麦克风
 */
@property (weak, nonatomic) IBOutlet UIButton *closeMicButton;

/**
 免提
 */
@property (weak, nonatomic) IBOutlet UIButton *switchReceiverButton;

/**
 文本输入
 */
@property (weak, nonatomic) IBOutlet UIButton *noteButton;

@end



@implementation M8MeetDeviceView

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

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)configButtonBackImgs {
    
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    
    BOOL isOn = [manager getCurCameraState];
    [self.closeCameraButton setBackgroundImage:[UIImage imageNamed:(!isOn ? @"liveCamera_off" : @"liveCamera_on")]
                                      forState:UIControlStateNormal];
    
    BOOL micState = [manager getCurMicState];
    [self.closeMicButton setBackgroundImage:[UIImage imageNamed:(!micState? @"liveMic_off" : @"liveMic_on")]
                                   forState:UIControlStateNormal];
    
    QAVOutputMode audioMode = [manager getCurAudioMode];
    [self.switchReceiverButton setBackgroundImage:[UIImage imageNamed:(audioMode == QAVOUTPUTMODE_EARPHONE ? @"liveReceiver_off" : @"liveReceiver_on")]
                                         forState:UIControlStateNormal];
}

#pragma mark device actions
- (IBAction)onShareAction:(id)sender {
    [self deviceActionInfoValue:@"onShareAction" key:kDeviceAction];
}



- (IBAction)onSwitchCameraAction:(id)sender {
    [self deviceActionInfoValue:@"onSwitchCameraAction" key:kDeviceAction];
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    int pos = [manager getCurCameraPos];
    
    if (pos == -1) {

        [self deviceActionInfoValue:@"摄像头没有打开" key:kDeviceText];
    }
    else {
        [manager switchCamera:^{
            [self deviceActionInfoValue:@"切换摄像头成功" key:kDeviceText];
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            [self deviceActionInfoValue:[NSString stringWithFormat:@"切换摄像头失败:%@-%d-%@",module,errId,errMsg] key:kDeviceText];
        }];
    }
}

- (IBAction)onCloseCameraAction:(id)sender {
    [self deviceActionInfoValue:@"onCloseCameraAction" key:kDeviceAction];
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurCameraState];
    cameraPos pos = [manager getCurCameraPos];
    __weak typeof(self) ws = self;
    [manager enableCamera:pos enable:!isOn succ:^{
        [ws.closeCameraButton setBackgroundImage:[UIImage imageNamed:(!isOn ? @"liveCamera_on" : @"liveCamera_off")]
                                        forState:UIControlStateNormal];
    }failed:^(NSString *moudle, int errId, NSString *errMsg) {
    }];
}

- (IBAction)onHangupAction:(id)sender {
    [self deviceActionInfoValue:@"onHangupAction" key:kDeviceAction];
}

- (IBAction)onCloseMicAction:(id)sender {
    [self deviceActionInfoValue:@"onCloseMicAction" key:kDeviceAction];
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    NSString *text = isOn ? @"关闭麦克风成功" : @"打开麦克风成功";
    WCWeakSelf(self);
    
    [manager enableMic:!isOn succ:^{
        [weakself deviceActionInfoValue:text key:kDeviceText];
        [weakself.closeMicButton setBackgroundImage:[UIImage imageNamed:(!isOn? @"liveMic_on" : @"liveMic_off")]
                                     forState:UIControlStateNormal];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        [weakself deviceActionInfoValue:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg] key:kDeviceText];
    }];
}

- (IBAction)onSwitchReceiverAction:(id)sender {
    [self deviceActionInfoValue:@"onSwitchReceiverAction" key:kDeviceAction];
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    QAVOutputMode mode = [manager getCurAudioMode];
    
    
    if(mode == QAVOUTPUTMODE_EARPHONE){
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
        [self deviceActionInfoValue:@"切换扬声器成功" key:kDeviceText];
        [self.switchReceiverButton setBackgroundImage:kGetImage(@"liveReceiver_on") forState:UIControlStateNormal];
    }
    else{
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
        [self deviceActionInfoValue:@"切换听筒成功" key:kDeviceText];
        [self.switchReceiverButton setBackgroundImage:kGetImage(@"liveReceiver_off") forState:UIControlStateNormal];
    }
}

- (IBAction)onNoteAction:(id)sender {
    [self deviceActionInfoValue:@"onNoteAction" key:kDeviceAction];
}

#pragma mark - MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(MeetDeviceActionInfo:)]) {
        [self.WCDelegate MeetDeviceActionInfo:actionInfo];
    }
}




@end
