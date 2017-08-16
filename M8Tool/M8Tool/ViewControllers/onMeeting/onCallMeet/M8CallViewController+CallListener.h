//
//  M8CallViewController+CallListener.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController.h"

@interface M8CallViewController (CallListener)<TILCallMemberEventListener, TILCallNotificationListener, RenderModelMangerDelegate>

/**
 可以开始处理从通讯录中邀请的成员
 */
- (void)onReceiveInviteMembers;

@end
