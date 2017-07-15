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
