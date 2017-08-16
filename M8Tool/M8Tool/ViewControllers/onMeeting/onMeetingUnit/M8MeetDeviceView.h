//
//  M8MeetDeviceView.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceTypeCallVideoHost,
    DeviceTypeCallVideoGust,
    DeviceTypeCallAudioHost,
    DeviceTypeCallAudioGust,
    DeviceTypeLiveHost,
    DeviceTypeLiveGust
};


@protocol M8MeetDeviceViewDelegate <NSObject>

- (void)M8MeetDeviceViewActionInfo:(NSDictionary *_Nonnull)actionInfo;

@end

@interface M8MeetDeviceView : UIView

@property (nonatomic, weak) id<M8MeetDeviceViewDelegate> _Nullable WCDelegate;


- (void)setCenterBtnImg:(NSString *_Nonnull)imgStr;

@end
