//
//  M8UserInfoCache.h
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 使用 NSUserDefaults 来保存用户的缓存信息
 */
@interface M8UserInfoCache : NSObject

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



//=======================================

/**
 保存用户所有的好友信息

 @param membersArr 元素是 M8MemberInfo *
 */
- (void)saveCacheAllFriends:(NSArray * _Nullable)membersArr;


@end
