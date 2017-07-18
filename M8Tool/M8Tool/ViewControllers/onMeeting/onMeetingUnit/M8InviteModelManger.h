//
//  M8InviteModelManger.h
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于管理邀请的成员信息 统一用 <--M8MemberInfo--> 类记录
 */
@interface M8InviteModelManger : NSObject

+ (instancetype _Nullable)shareInstance;

/**
 记录发起call时邀请的成员，在选人的时候不能被反选
 */
@property (nonatomic, strong, nullable) NSMutableArray *inviteMemberArray;

/**
 记录选中的成员
 */
@property (nonatomic, strong, nullable) NSMutableArray *selectMemberArray;


/**
 发起界面选择人的时候需要根据选中的成员更新数组

 @param currentArray 发起界面选中的成员
 */
- (void)updateInviteMemberArray:(NSArray *_Nullable)currentArray;


//- (void)addMemberWithUid:(NSString *_Nullable)uid;

/**
 判断用户是否在初始数组中

 @param uid 用户ID
 @return 存在数据
 */
- (BOOL)isExistInviteArray:(NSString *_Nullable)uid;

/**
 判断用户是否在选择的数组中
 
 @param uid 用户ID
 @return 存在数据
 */
- (BOOL)isExistSelectArray:(NSString *_Nullable)uid;


- (void)onSelectAtMemberInfo:(M8MemberInfo *_Nullable)member;
@end
