//
//  M8LiveViewController+Net.h
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveViewController.h"

@interface M8LiveViewController (Net)


/**
 上报房间信息
 */
- (void)onNetReportRoomInfo;

/**
 上报退出房间
 */
- (void)onNetReportExitRoom;

@end
