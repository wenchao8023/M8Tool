//
//  OnMeetRecvListener.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 监听来电（因为直播中没有直接邀请的方法，所以使用IMSDK中发消息来实现call）
 */
@interface OnMeetRecvListener : NSObject<ILVLiveIMListener>

@end
