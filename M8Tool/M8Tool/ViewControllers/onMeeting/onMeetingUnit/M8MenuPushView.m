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
    M8MeetType _meetType;
    TILMultiCall *_call;
}
@end



@implementation M8MenuPushView

- (instancetype)initWithFrame:(CGRect)frame itemCount:(int)itemCount meetType:(M8MeetType)meetType call:(TILMultiCall *)call
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = WCClear;
        
        _itemCount = itemCount;
        _meetType  = meetType;
        _call      = call;
        
        if (meetType == M8MeetTypeCall)
        {
            //保证音频输出是开的
            if (![_call isSpeakerEnabled])
            {
                [_call enableSpeaker:YES result:nil];
            }
            if (itemCount == 3)
            {
                //在音频模式下 确保摄像头是关的
                if ([_call isCameraEnabled])
                {
                    [_call enableCamera:NO pos:TILCALL_CAMERA_POS_NONE result:nil];
                }
                _btnImgsArray = @[@"liveMic_on", @"liveReceiver_on", @"liveInvite"];
            }
            else if (itemCount == 5)
            {
                _btnImgsArray = @[@"liveMic_on", @"liveReceiver_on", @"liveCamera_on", @"liveSwitchCamera", @"liveInvite"];
            }
        }
        else
        {
            //加载直播菜单中的按钮
        }
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];
        
        
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
 
 * 直播
 1. closeMic
 2. switchReciver
 3. share
 
 * 视频
 1. closeMic
 2. switchReciver
 3. closeCamera
 4. switchCamera
 5. share
 */
- (void)btnAction:(UIButton *)btn
{
    NSInteger tag = btn.tag;
    if (_meetType == M8MeetTypeCall)
    {
        if (_itemCount == 3)
        {
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
//                    [self onResponseToDelegate:@"onInviteAction"];
                    [self onResponseToDelegate:@"onInviteAction" key:kMenuPushAction];
                }
                    break;
                default:
                    break;
            }
        }
        if (_itemCount == 5)
        {
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
                case 105:
                {
//                    [self onResponseToDelegate:@"onInviteAction"];
                    [self onResponseToDelegate:@"onInviteAction" key:kMenuPushAction];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


//- (void)onResponseToDelegate:(id)actionStr
//{
//    if ([self.WCDelegate respondsToSelector:@selector(MenuPushActionInfo:)])
//    {
//        [self.WCDelegate MenuPushActionInfo:@{kMenuPushAction : actionStr}];
//    }
//}

- (void)onResponseToDelegate:(id)value key:(NSString *)key
{
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(MenuPushActionInfo:)])
    {
        [self.WCDelegate MenuPushActionInfo:actionInfo];
    }
}




- (void)onCloseMicAction:(UIButton *)btn
{
    if (_meetType == M8MeetTypeCall)
    {
        BOOL isOn = [_call isMicEnabled];
        [_call enableMic:!isOn result:^(TILCallError *err) {
            
            if (!err)
            {
                [btn setBackgroundImage:[UIImage imageNamed:(!isOn? @"liveMic_on" : @"liveMic_off")]
                               forState:UIControlStateNormal];
            }
        }];
    }
    
//    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
//    BOOL isOn = [manager getCurMicState];
//    [manager enableMic:!isOn succ:^{
//        
//        [btn setBackgroundImage:[UIImage imageNamed:(!isOn? @"liveMic_on" : @"liveMic_off")]
//                                           forState:UIControlStateNormal];
//        
//    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
//        
//    }];
}

- (void)onSwitchReceiverAction:(UIButton *)btn
{
    if (_meetType == M8MeetTypeCall)
    {
        [_call switchAudioMode];
        
        TILCallAudioMode mode = [_call getAudioMode];
        
        if(mode == TILCALL_AUDIO_MODE_EARPHONE)
        {
            [_call enableSpeaker:NO result:^(TILCallError *err) {
                
                if (!err)
                {
                    [btn setBackgroundImage:kGetImage(@"liveReceiver_off") forState:UIControlStateNormal];
                }
            }];
            
        }
        else
        {
            [_call enableSpeaker:YES result:^(TILCallError *err) {
                
                if (!err)
                {
                    [btn setBackgroundImage:kGetImage(@"liveReceiver_on") forState:UIControlStateNormal];
                }
            }];
            
        }
//        BOOL isOn = [_call isSpeakerEnabled];
//        [_call enableSpeaker:!isOn result:^(TILCallError *err) {
//            
//            if (!err)
//            {
//                [btn setBackgroundImage:[UIImage imageNamed:(!isOn? @"liveReceiver_on" : @"liveReceiver_off")]
//                               forState:UIControlStateNormal];
//            }
//        }];    
    }
    
//    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
//    QAVOutputMode mode = [manager getCurAudioMode];
//    
//    if(mode == QAVOUTPUTMODE_EARPHONE)
//    {
//        [manager setAudioMode:QAVOUTPUTMODE_SPEAKER];
//
//        [btn setBackgroundImage:kGetImage(@"liveReceiver_on") forState:UIControlStateNormal];
//    }
//    else
//    {
//        [manager setAudioMode:QAVOUTPUTMODE_EARPHONE];
//
//        [btn setBackgroundImage:kGetImage(@"liveReceiver_off") forState:UIControlStateNormal];
//    }
}

- (void)onCloseCameraAction:(UIButton *)btn
{
    if (_meetType == M8MeetTypeCall)
    {
        BOOL isOn = [_call isCameraEnabled];
        [_call enableCamera:!isOn pos:TILCALL_CAMERA_POS_FRONT result:^(TILCallError *err) {
            
            if (!err)
            {
                [btn setBackgroundImage:[UIImage imageNamed:(!isOn ? @"liveCamera_on" : @"liveCamera_off")]
                                        forState:UIControlStateNormal];
            }
        }];
    }
//    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
//    BOOL isOn = [manager getCurCameraState];
//    cameraPos pos = [manager getCurCameraPos];
//    
//    [manager enableCamera:pos enable:!isOn succ:^{
//        
//        [btn setBackgroundImage:[UIImage imageNamed:(!isOn ? @"liveCamera_on" : @"liveCamera_off")]
//                       forState:UIControlStateNormal];
//        
//    } failed:^(NSString *moudle, int errId, NSString *errMsg) {
//    
//    }];
}


- (void)onSwitchCameraAction:(UIButton *)btn
{
    if (_meetType == M8MeetTypeCall)
    {
        BOOL isOn = [_call isCameraEnabled];
        if (isOn)
        {
            [_call switchCamera:nil];
        }
        else
        {
            [self onResponseToDelegate:@"请先打开摄像头" key:kMenuPushText];
        }
    }
//    ILiveRoomManager *manager = [ILiveRoomManager getInstance];
//    int pos = [manager getCurCameraPos];
//    
//    if (pos == -1)
//    {
//        
//    }
//    else
//    {
//        [manager switchCamera:^{
//
//        } failed:^(NSString *module, int errId, NSString *errMsg) {
//
//        }];
//    }
}





@end
