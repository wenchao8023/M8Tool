//
//  RecordViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//


#import "BaseViewController.h"





/**
 会议记录、会议笔记、会议收藏 viewController
 */
typedef enum : NSInteger {
    RecordViewType_record   = 0,
    RecordViewType_note     = 1,
    RecordViewType_collect  = 2,
}RecordViewType;
@interface RecordViewController : BaseViewController

@property (nonatomic, assign) RecordViewType recordViewType;

@end
