//
//  M8CallVideoDevice.h
//  M8Tool
//
//  Created by chao on 2017/6/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>






@protocol MeetDeviceDelegate <NSObject>

@optional
- (void)MeetDeviceActionInfo:(NSDictionary *_Nullable)actionInfo;

@end


/**
 设备控制
 
    * 分享这场会议
    * 关闭摄像头
    * 切换摄像头
    * 挂断
    * 静音
    * 免提
    * 文本输入 (textInputView)
 */
@interface M8CallVideoDevice : UIView

@property (nonatomic, weak) id<MeetDeviceDelegate> _Nullable WCDelegate;

- (void)configButtonBackImgs;

@end
