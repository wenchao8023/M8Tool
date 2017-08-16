//
//  UsrContactView+Net.h
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"

@interface UsrContactView (Net)


/**
 本地加载第一个分组里面的数据
 */
- (void)onNetLoadLocalList:(M8VoidBlock _Nullable )succHandle;


/**
 获取公司列表
 */
- (void)onNetGetCompanyList:(M8VoidBlock _Nullable )succHandle;


/**
 创建公司
 */
- (void)onNetCreateTeam:(NSString *_Nullable)teamName  succ:(M8VoidBlock _Nullable )succHandle;

/**
 删除部门
 */
- (void)onNetDeleteDepartmentForIndexPath:(NSIndexPath *_Nullable)indexPath succ:(M8VoidBlock _Nullable)succHandle;

@end
