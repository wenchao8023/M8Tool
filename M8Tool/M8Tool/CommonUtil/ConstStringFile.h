//
//  ConstStringFile.h
//  M8Tool
//
//  Created by chao on 2017/6/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#ifndef ConstStringFile_h
#define ConstStringFile_h


#pragma mark - strings in modify
static NSString * _Nonnull const kModifyText = @"kModifyText";
static NSString * _Nonnull const kModifyTime = @"kModifyTime";
static NSString * _Nonnull const kModifyDate = @"kModifyDate";

#pragma mark - strings in call
/// 成员状态提示
static NSString * _Nonnull const kMemberStatu_lineBusy      = @"占线";
static NSString * _Nonnull const kMemberStatu_reject        = @"拒绝";
static NSString * _Nonnull const kMemberStatu_timeout       = @"超时";
static NSString * _Nonnull const kMemberStatu_hangup        = @"挂断";
static NSString * _Nonnull const kMemberStatu_disconnect    = @"失去连接";
static NSString * _Nonnull const kMemberStatu_waiting       = @"连接中...";

/// M8MeetDeviceView
//  key
static NSString * _Nonnull const kDeviceAction              = @"deviceAction";
static NSString * _Nonnull const kDeviceText                = @"deviceText";
//  value
typedef NS_ENUM(NSInteger, kOnDeviceAction)
{
    kOnDeviceActionShare,
    kOnDeviceActionNote,
    kOnDeviceActionCenter,
    kOnDeviceActionMenu,
    kOnDeviceActionSwichRender
};



/// M8CallAudioDevice
static NSString * _Nonnull const kCallAudioDeviceAction   = @"CallAudioDeviceAction";
static NSString * _Nonnull const kCallAudioDeviceText     = @"CallAudioDeviceText";

/// M8CallRenderView
static NSString * _Nonnull const kCallAction                = @"kCallAction";
static NSString * _Nonnull const kCallText                  = @"kCallText";
static NSString * _Nonnull const kCallValue_bool            = @"kCallValue_bool";
static NSString * _Nonnull const kCallValue_id              = @"kCallValue_id";
static NSString * _Nonnull const kCallValue_model           = @"kCallValue_model";  // dic: @{model : identify}

/// M8CallHeaderView
static NSString * _Nonnull const kHeaderAction              = @"kHeaderAction";
static NSString * _Nonnull const kHeaderText                = @"kHeaderText";

static NSString * _Nonnull const kMenuPushAction            = @"kMenuPushAction";
static NSString * _Nonnull const kMenuPushText              = @"kMenuPushText";


#pragma mark - strings in live
/// M8LiveDeviceView
static NSString  * _Nonnull const kLiveDeviceAction         = @"kLiveDeviceAction";
static NSString  * _Nonnull const kLiveDeviceText           = @"kLiveDeviceText";



#pragma mark - strings in timeformatter
/// 表示会议记录中的的时间格式，从上往下优先级依次增加
static NSString  * _Nonnull const kTimeformatterYear        = @"yy-MM-dd";  // 上年
static NSString  * _Nonnull const kTimeformatterMonth       = @"MM-dd";     // 本年其他月份
static NSString  * _Nonnull const kTimeformatterWeak        = @"HH";        // 本周其他天
static NSString  * _Nonnull const kTimeformatterLday        = @"HH";        // 昨天
static NSString  * _Nonnull const kTimeformatterDay         = @"HH:mm";     // 今天






#endif /* ConstStringFile_h */
