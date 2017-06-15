//
//  M8CallAudioDevice.h
//  M8Tool
//
//  Created by chao on 2017/6/10.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString  * _Nullable  kCallAudioDeviceAction  = @"CallAudioDeviceAction";
static NSString  * _Nullable  kCallAudioDeviceText    = @"CallAudioDeviceText";


@protocol CallAudioDeviceDelegate <NSObject>

@optional
- (void)CallAudioDeviceActionInfo:(NSDictionary *_Nullable)actionInfo;

@end


@interface M8CallAudioDevice : UIView

@property (nonatomic, weak) id _Nullable WCDelegate;

- (void)configButtonBackImgs ;

@end
