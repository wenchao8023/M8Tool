//
//  M8MeetRenderView.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 会议成员状态
 
    * 主播
    * 有视频上行的连麦观众
    * 没有视频上行的连麦观众
    * 邀请上麦
    * 移除连麦观众
 */


@interface M8MeetRenderView : UIView<ILVLiveAVListener>

/**
 房间号
 */
@property (nonatomic, assign) NSInteger roomId;

/**
 主播
 */
@property (nonatomic, copy, nullable) NSString *host;


@end
