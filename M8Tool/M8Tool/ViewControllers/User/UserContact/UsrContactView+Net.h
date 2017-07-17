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
- (void)onNetLoadLocalList:(TCIVoidBlock _Nullable )succHandle;


/**
 获取公司列表
 */
- (void)onNetGetCompanyList:(TCIVoidBlock _Nullable )succHandle;


/**
 创建公司
 */
- (void)onNetCreateTeam:(NSString *_Nullable)teamName  succ:(TCIVoidBlock _Nullable )succHandle;

@end
