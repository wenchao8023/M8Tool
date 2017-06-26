//
//  M8CallAudioDevice.h
//  M8Tool
//
//  Created by chao on 2017/6/10.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol CallAudioDeviceDelegate <NSObject>

@optional
- (void)CallAudioDeviceActionInfo:(NSDictionary *_Nullable)actionInfo;

@end


@interface M8CallAudioDevice : UIView

@property (nonatomic, weak) id<CallAudioDeviceDelegate> _Nullable WCDelegate;

- (void)configButtonBackImgs ;

@end
