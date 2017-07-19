//
//  M8MeetRecordModel.h
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface M8MeetMemberInfo : NSObject

@property (nonatomic, copy, nullable) NSString *user;       //成员ID
@property (nonatomic, copy, nullable) NSString *statu;      //成员状态（0-未响应，1-接听，2-拒绝）
@property (nonatomic, copy, nullable) NSString *entertime;  //成员进入房间时间
@property (nonatomic, copy, nullable) NSString *exittime;   //成员退出房间时间
@property (nonatomic, copy, nullable) NSString *nick;       //成员nick


/**
 转成json数据格式
 */
- (NSDictionary *_Nonnull)toDictionary;

@end




@interface M8MeetRecordModel : NSObject

@property (nonatomic, copy, nullable) NSString *mid;        //会议id
@property (nonatomic, copy, nullable) NSString *title;      //主题
@property (nonatomic, copy, nullable) NSString *mainuser;   //发起人
@property (nonatomic, copy, nullable) NSString *type;       //会议类型
@property (nonatomic, copy, nullable) NSString *starttime;  //会议开始时间
@property (nonatomic, copy, nullable) NSString *endtime;    //会议结束时间
@property (nonatomic, assign) int collect;    //是否收藏（0-未收藏，1-收藏）
@property (nonatomic, strong, nullable) NSArray *members;   //参会成员列表

/**
 转成json数据格式
 */
- (NSDictionary *_Nonnull)toDictionary;


@end
