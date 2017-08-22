//
//  M8MeetRecordTableView+Net.h
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRecordTableView.h"

@interface M8MeetRecordTableView (Net)

/**
 *  请求会议记录
 */
- (void)loadNetData;


/**
 *  请求更多会议记录
 */
- (void)loadMoreData;
@end
