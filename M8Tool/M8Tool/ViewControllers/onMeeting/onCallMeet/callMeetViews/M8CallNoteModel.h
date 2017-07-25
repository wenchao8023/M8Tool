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
 也可以是用户发送的消息
 */
@property (nonatomic, copy, nullable) NSString *tipInfo;


/**
 初始化

 @param tipInfo 提示信息
 @return self
 */
- (instancetype _Nullable)initWithTip:(NSString *_Nullable)tipInfo;


/**
 初始化

 @param member 成员名
 @param tipInfo 成员发表内容
 @return self
 */
- (instancetype _Nullable)initWithMember:(NSString *_Nullable)member Tip:(NSString *_Nullable)tipInfo;
@end
