//
//  M8DeviceView.h
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


@protocol M8DeviceViewDelegate <NSObject>

- (void)M8DeviceViewActionInfo:(NSDictionary *_Nonnull)actionInfo;

@end

@interface M8DeviceView : UIView

@property (nonatomic, weak) id<M8DeviceViewDelegate> _Nullable WCDelegate;

@end
