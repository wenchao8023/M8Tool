//
//  UsrContactFriendCell.h
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsrContactFriendCell : UITableViewCell

/**
 配置第一分组里面的项
 */
- (void)configWithItem:(NSString *_Nullable)itemImg itemText:(NSString *_Nullable)itemText;

/**
 配置部门信息
 */
- (void)configWithDepartmentItem:(id _Nullable)dInfo;

/**
 配置好友列表
 */
- (void)configWithFriendItem:(id _Nullable)friendInfo;


/**
 配置默认状态下的样式
 */
- (void)configWithMemberItem:(id _Nullable)memberInfo;


/**
 配置管理者进入，- 可编辑样式
 */
- (void)configMemberItemEditing:(id _Nullable)memberInfo;

/**
 配置选择模式下成员选中状态

 @param memberInfo 成员
 @param selected 是否选中
 */
- (void)configMemberItem:(id _Nullable)memberInfo isSelected:(BOOL)selected;

@end
