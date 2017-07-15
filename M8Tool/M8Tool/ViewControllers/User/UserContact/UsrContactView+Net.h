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
- (void)onNetLoadLocalList:(TCIVoidBlock)succHandle;


/**
 获取公司列表
 */
- (void)onNetGetCompanyList:(TCIVoidBlock)succHandle;


/**
 获取好友列表
 */
- (void)onNetGetFriendList:(TCIVoidBlock)succHandle;



@end
