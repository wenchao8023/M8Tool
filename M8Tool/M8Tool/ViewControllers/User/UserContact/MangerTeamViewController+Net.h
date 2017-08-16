//
//  MangerTeamViewController+Net.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController.h"


@interface MangerTeamViewController (Net)

- (void)onNetloadData;

- (void)onNetGetPartInfoWithDid:(NSString *_Nonnull)did;

/**
 删除公司
 */
- (void)onNetDeleteCompany;

/**
 创建部门
 */
- (void)onNetCreateDepartment:(NSString *_Nullable)partName;

/**
 获取公司详情
 */
- (void)onNetGetCompanyDetail;


//
/**
 添加单个成员进部门

 @param memberId 成员ID
 @param did 部门ID
 @param succHandle 成功回调
 */
- (void)onNetJoinMember:(NSString *_Nullable)memberId toPart:(NSString *_Nullable)did succ:(M8VoidBlock _Nullable)succHandle;
@end
