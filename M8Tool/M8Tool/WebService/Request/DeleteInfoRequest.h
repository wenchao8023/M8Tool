//
//  DeleteInfoRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/24.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 删除公司、部门、好友请求
 */
@interface DeleteInfoRequest : NSObject


@end


/**
 删除公司
 */
@interface DeleteCompanyReuqest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, assign) int cid;  //公司ID


@end


/**
 删除部门
 */
@interface DeleteDepartmentReuqest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;
@property (nonatomic, assign) int did; //部门ID


@end


/**
 删除好友
 */
@interface DeleteFriendReuqest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;   //用户ID
@property (nonatomic, copy, nullable) NSString *fid;     //好友ID


@end
