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

/**
 将会议中的数组转成self数组中的数据
 
 @param callRenderModelArr 发起界面选中的成员 M8CallRenderModel
 */
- (void)updateInviteM8CallRenderModelArray:(NSArray *_Nullable)callRenderModelArr;

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


- (NSString *_Nullable)nickInInviteArrayWithUid:(NSString *_Nullable)uid;


/**
 点击 cell 进行选择和反选

 @param member 成员
 */
- (void)onSelectAtMemberInfo:(M8MemberInfo *_Nullable)member;


/**
 合并 selectArray 和 inviteArray 中的成员，并将 selectArray 置空
 */
- (void)mergeSelectToInvite;


/**
 移除所有数组中的所有成员
 */
- (void)removeAllMembers;


/**
 移除 inviteArray 中的所有成员
 */
- (void)removeInviteMembers;


/**
 移除 selectArray 中的所有成员
 */
- (void)removeSelectMembers;


@end
