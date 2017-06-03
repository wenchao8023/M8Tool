//
//  UserContactViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/22.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  进入联系人界面的类型
 *  ContactType_contact : 显示用户的公司关系链
 *  ContactType_tel     : 使用 普通手机通话 提供联系人名字及手机号，方便直接拨打电话
 *  ContactType_sel     : 从会议发起界面进入 选人时的类型
 */
typedef enum : NSInteger {
    
    ContactType_contact,
    ContactType_tel,
    ContactType_sel
    
}ContactType;

/**
 *  通讯录、手机通话界面
 */
@interface UserContactViewController : BaseViewController


@property (nonatomic, assign) ContactType contactType;

@end
