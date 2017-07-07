//
//  M8MenuPushView.m
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MenuPushView.h"



@interface M8MenuPushView ()
{
    int _itemCount;
    NSArray *_btnImgsArray;
}
@end



@implementation M8MenuPushView

- (instancetype)initWithFrame:(CGRect)frame itemCount:(int)itemCount meetType:(M8MeetType)meetType
{
    if (self = [super initWithFrame:frame])
    {
        if (meetType == M8MeetTypeCall)
        {
            _btnImgsArray = @[@"liveMic_on", @"liveReceiver_on", @"liveCamera_on", @"liveSwitchCamera"];
        }
        else
        {
            //加载直播菜单中的按钮
        }
        
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        
        self.backgroundColor = WCClear;
        _itemCount = itemCount;
        [self addItems];
    }
    return self;
}



- (void)addItems
{
    for (int i = 0; i < _itemCount; i++)
    {
        UIButton *btn = [WCUIKitControl createButtonWithFrame:CGRectMake(10 * (i + 1) + 40 * i, 5, 40, 40) Target:self Action:@selector(btnAction:) ImageName:_btnImgsArray[i]];
        btn.tag = 101 + i;
        WCViewBorder_Radius(btn, 20);
        [self addSubview:btn];
    }
}

/**
 按钮事件

 1. closeMic
 2. switchReciver
 3. closeCamera
 4. switchCamera
 */
- (void)btnAction:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    switch (tag) {
        case 101:
        {
            [self onCloseMicAction:btn];
        }
            break;
        case 102:
        {
            [self onSwitchReceiverAction:btn];
        }
            break;
        case 103:
        {
            [self onCloseCameraAction:btn];
        }
            break;
        case 104:
        {
            [self onSwitchCameraAction:btn];
        }
            break;
        default:
            break;
    }
}
- (void)onCloseMicAction:(UIButton *)btn
{
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurMicState];
    [manager enableMic:!isOn succ:^{
        
        [btn setBackgroundImage:[UIImage imageNamed:(!isOn? @"liveMic_on" : @"liveMic_off")]
                                           forState:UIControlStateNormal];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
        
    }];
}

- (void)onSwitchReceiverAction:(UIButton *)btn
{

    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    QAVOutputMode mode = [manager getCurAudioMode];
    
    
    if(mode == QAVOUTPUTMODE_EARPHONE)
    {
        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];

        [btn setBackgroundImage:kGetImage(@"liveReceiver_on") forState:UIControlStateNormal];
    }
    else
    {
        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];

        [btn setBackgroundImage:kGetImage(@"liveReceiver_off") forState:UIControlStateNormal];
    }
}

- (void)onCloseCameraAction:(UIButton *)btn
{
    
    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    BOOL isOn = [manager getCurCameraState];
    cameraPos pos = [manager getCurCameraPos];
    
    [manager enableCamera:pos enable:!isOn succ:^{
        
        [btn setBackgroundImage:[UIImage imageNamed:(!isOn ? @"liveCamera_on" : @"liveCamera_off")]
                       forState:UIControlStateNormal];
        
    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
    
    }];
}


- (void)onSwitchCameraAction:(UIButton *)btn
{

    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
    int pos = [manager getCurCameraPos];
    
    if (pos == -1)
    {

    }
    else
    {
        [manager switchCamera:^{

        } failed:^(NSString *module, int errId, NSString *errMsg) {

        }];
    }
}





@end
