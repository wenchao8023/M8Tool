//
//  M8LiveDeviceView.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveDeviceView.h"




@interface M8LiveDeviceView ()
{
    M8LiveDeviceType _liveDeviceType;
}
@property (weak, nonatomic) IBOutlet UIButton *leftButton1;

@property (weak, nonatomic) IBOutlet UIButton *leftButton2;

@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton1;

@property (weak, nonatomic) IBOutlet UIButton *rightButton2;



@end




@implementation M8LiveDeviceView

- (void)configDeviceWithType:(M8LiveDeviceType)deviceType {
    _liveDeviceType = deviceType;
    if (deviceType == M8LiveDeviceTypeHost) {   ///> 主播
        
    }
    else {  ///> 观众
        
    }
}


- (IBAction)leftButton1Action:(id)sender {
    if (_liveDeviceType == M8LiveDeviceTypeHost) {   ///> 主播
        [self deviceActionInfoValue:@"主播分享" key:kLiveDeviceAction];
    }
    else {  ///> 观众
        [self deviceActionInfoValue:@"观众分享" key:kLiveDeviceAction];
    }
}

- (IBAction)leftButton2Action:(id)sender {
    if (_liveDeviceType == M8LiveDeviceTypeHost) {   ///> 主播
        [self deviceActionInfoValue:@"主播切换摄像头" key:kLiveDeviceAction];
    }
    else {  ///> 观众
        [self deviceActionInfoValue:@"观众私信" key:kLiveDeviceAction];
    }
}

- (IBAction)centerButtonAction:(id)sender {
    if (_liveDeviceType == M8LiveDeviceTypeHost) {   ///> 主播
        [self deviceActionInfoValue:@"主播退出" key:kLiveDeviceAction];
    }
    else {  ///> 观众
        [self deviceActionInfoValue:@"观众特效" key:kLiveDeviceAction];
    }
}

- (IBAction)rightButton1Action:(id)sender {
    if (_liveDeviceType == M8LiveDeviceTypeHost) {   ///> 主播
        [self deviceActionInfoValue:@"主播静麦" key:kLiveDeviceAction];
    }
    else {  ///> 观众
        [self deviceActionInfoValue:@"观众评论" key:kLiveDeviceAction];
    }
}

- (IBAction)rightButton2Action:(id)sender {
    if (_liveDeviceType == M8LiveDeviceTypeHost) {   ///> 主播
        [self deviceActionInfoValue:@"主播评论" key:kLiveDeviceAction];
    }
    else {  ///> 观众
        [self deviceActionInfoValue:@"观众退出" key:kLiveDeviceAction];
    }
}


#pragma mark - MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(LiveDeviceViewActionInfo:)]) {
        [self.WCDelegate LiveDeviceViewActionInfo:actionInfo];
    }
}



@end
