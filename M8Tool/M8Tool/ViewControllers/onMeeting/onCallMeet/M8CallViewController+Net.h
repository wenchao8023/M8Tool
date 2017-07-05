//
//  M8CallViewController+Net.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController.h"

@interface M8CallViewController (Net)

/**
 上报房间信息
 */
- (void)onNetReportRoomInfo;

/**
 上报成员信息

 @param mem 会议ID
 @param statu 成员状态,0:未接听（默认）, 1:接听, 2:拒绝
 */
- (void)onNetReportCallMem:(NSString * _Nonnull)mem statu:(int)statu;

/**
 上报退出房间
 */
- (void)onNetReportExitRoom;

@end
