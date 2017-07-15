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

@end
