//
//  M8MeetRecordCell.h
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M8MeetRecordModel;

/**
 可以做 会议记录、会议笔记、会议收藏的 cell
 */
@interface M8MeetRecordCell : UITableViewCell

- (void)config:(M8MeetRecordModel *)model;

@end
