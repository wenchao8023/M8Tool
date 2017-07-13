//
//  M8MeetListCache.h
//  M8Tool
//
//  Created by chao on 2017/7/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M8MeetListCache : NSObject


/**
 保存会议列表到本地
 如果会议列表为空，则清除本地数据

 @param dataArray 会议列表
 */
+ (void)addMeetListToLocal:(NSArray *_Nonnull)dataArray;


/**
 获取本地会议列表
 如果为空则表示没有数据
 
 @return M8MeetListModel - dictionary格式
 */
+ (NSArray *_Nullable)localMeetList;

/**
 获取本地会议列表中第一条数据
 如果为空则表示没有数据
 @return M8MeetListModel
 */
+ (id _Nullable)topModelFromLocalMeetList;


@end
