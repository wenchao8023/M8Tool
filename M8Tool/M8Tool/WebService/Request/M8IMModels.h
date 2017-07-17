//
//  M8IMModels.h
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 IMSDK中 用户信息字段 tag
 */
static NSString * _Nonnull const kSnsProfileItemTag_Nick = @ "Tag_Profile_IM_Nick";


/**
 *  进入联系人界面的类型
 *  ContactType_contact : 显示用户的公司关系链
 *  ContactType_tel     : 使用 普通手机通话 提供联系人名字及手机号，方便直接拨打电话
 *  ContactType_sel     : 从会议发起界面进入 选人时的类型
 */
typedef NS_ENUM(NSInteger, ContactType)
{
    ContactType_contact,
    ContactType_tel,
    ContactType_sel
};




@interface M8IMModels : NSObject

@end



/**
 好友信息
 */
@interface M8FriendInfo : NSObject

@property (nonatomic, copy, nullable) NSString *Info_Account;
@property (nonatomic, strong, nullable) NSArray *SnsProfileItem;

@end



/**
 用于保存自己后台返回的昵称+ID
 */
@interface M8MemberInfo : NSObject

@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, copy, nullable) NSString *nick;


@end


/**
 部门信息
 */
@interface M8DepartmentInfo : NSObject

@property (nonatomic, copy, nullable) NSString *did;
@property (nonatomic, copy, nullable) NSString *dname;

@end



/**
 公司信息
 */
@interface M8CompanyInfo : NSObject

@property (nonatomic, copy, nullable) NSString *cid;            //公司ID
@property (nonatomic, copy, nullable) NSString *cname;          //公司名
@property (nonatomic, copy, nullable) NSString *uid;            //创建公司用户
@property (nonatomic, strong, nullable) NSArray *departments;   //公司中的部门数组 M8DepartmentInfo

@end
