//
//  M8CallNoteModel.h
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8CallNoteModel : NSObject

/**
 判断是否记录了    默认为空
 */
@property (nonatomic, assign) BOOL record;

/**
 用户名    默认为空
 
 为空的时候表示只有提示信息
 不为空则表示是某用户发送的消息
 */
@property (nonatomic, copy, nullable) NSString *name;

/**
 提示信息
 
 可以是 "xxx进入会议室"
 */
@property (nonatomic, copy, nullable) NSString *tipInfo;


/**
 用户发送的消息
 */
@property (nonatomic, copy, nullable) NSString *msgInfo;


/**
 初始化
 
 @param member 成员名
 @param tip 提示信息
 @return self
 */
- (instancetype _Nullable)initWithMember:(NSString *_Nullable)member tip:(NSString *_Nullable)tip;


/**
 初始化

 @param member 成员名
 @param msg 成员发送的消息
 @return self
 */
- (instancetype _Nullable)initWithMember:(NSString *_Nullable)member msg:(NSString *_Nullable)msg;
@end
