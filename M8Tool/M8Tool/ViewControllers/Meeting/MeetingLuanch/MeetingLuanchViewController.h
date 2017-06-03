//
//  MeetingLuanchViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"

/**
 创建 电话会议、视频会议、直播会议、预约会议
 
 */
typedef enum : NSInteger {
    
    LuanchMeetingType_phone = 0,
    LuanchMeetingType_video = 1,
    LuanchMeetingType_live  = 2,
    LuanchMeetingType_order = 4
    
}LuanchMeetingType;


@interface MeetingLuanchViewController : BaseViewController

@property (nonatomic, assign) LuanchMeetingType luanchMeetingType;

@end
