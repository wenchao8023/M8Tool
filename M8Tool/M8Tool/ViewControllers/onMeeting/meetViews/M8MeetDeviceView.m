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
 关闭摄像头
 */
@property (weak, nonatomic) IBOutlet UIButton *closeCameraButton;

/**
 切换摄像头
 */
@property (weak, nonatomic) IBOutlet UIButton *swichCameraButton;

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
//        self.backgroundColor = WCBgColor;
    }
    return self;
}


#pragma mark device actions
- (IBAction)onShareAction:(id)sender {
    [self deviceActionInfoValue:@"onShareAction" key:kDeviceAction];
}

- (IBAction)onCloseCameraAction:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurCameraState];
    cameraPos pos = [manager getCurCameraPos];
    __weak typeof(self) ws = self;
    [manager enableCamera:pos enable:!isOn succ:^{
//                [ws.closeCameraButton setBackgroundImage:[UIImage imageNamed:(!isOn ? @"shelu_b" : @"shelu")]
//                                                forState:UIControlStateNormal];
    }failed:^(NSString *moudle, int errId, NSString *errMsg) {
    }];
}

- (IBAction)onSwitchCameraAction:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    int pos = [manager getCurCameraPos];
    
    if (pos == -1) {

        [self deviceActionInfoValue:@"摄像头没有打开" key:kDeviceText];
    }
    else {
        __weak typeof(self) ws = self;
        [manager switchCamera:^{

            [self deviceActionInfoValue:@"切换摄像头成功" key:kDeviceText];
            
//            [ws.swichCameraButton setBackgroundImage:[UIImage imageNamed:(!pos? @"zhuanhua_b" : @"zhuanhua")]
//                                            forState:UIControlStateNormal];
        } failed:^(NSString *module, int errId, NSString *errMsg) {
            
            [self deviceActionInfoValue:[NSString stringWithFormat:@"切换摄像头失败:%@-%d-%@",module,errId,errMsg] key:kDeviceText];
        }];
    }
}

- (IBAction)onHangupAction:(id)sender {
    TILLiveManager *manager = [TILLiveManager getInstance];
    [manager quitRoom:^{
        
        [self deviceActionInfoValue:@"quitRoomSucc" key:kDeviceAction];
        
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        
        NSString *info = [NSString stringWithFormat:@"module : %@ \nerrId : %d\nerrMsg : %@", module, errId, errMsg];
        [self deviceActionInfoValue:info key:kDeviceText];
    }];
}

- (IBAction)onCloseMicAction:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    __weak typeof(self) ws = self;
    [manager enableMic:!isOn succ:^{
        
        NSString *text = !isOn ? @"打开麦克风成功" : @"关闭麦克风成功";
        [self deviceActionInfoValue:text key:kDeviceText];
        
//        [ws.closeMicButton setBackgroundImage:[UIImage imageNamed:(isOn? @"jingyin_b" : @"jingyin")]
//                                     forState:UIControlStateNormal];
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        NSString *text = !isOn?@"打开麦克风失败":@"关闭麦克风失败";

        [self deviceActionInfoValue:[NSString stringWithFormat:@"%@:%@-%d-%@",text,moudle,errId,errMsg] key:kDeviceText];
    }];
}

- (IBAction)onSwitchReceiverAction:(id)sender {
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    __weak typeof(self) ws = self;
    QAVOutputMode mode = [manager getCurAudioMode];

    [self deviceActionInfoValue:(mode == QAVOUTPUTMODE_EARPHONE?@"切换扬声器成功":@"切换到听筒成功") key:kDeviceText];
    
//    [ws.switchReceiverButton setBackgroundImage:[UIImage imageNamed:(mode == QAVOUTPUTMODE_EARPHONE?@"mianti_b" : @"mianti")]
//                                       forState:UIControlStateNormal];
    if(mode == QAVOUTPUTMODE_EARPHONE){
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
    }
    else{
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
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

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}



@end
