//
//  CreatePartRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

/**
 创建部门请求
 */
@interface CreatePartRequest : BaseRequest

@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic, copy, nullable) NSString *uid;    
@property (nonatomic, assign)         int      cid;     //公司ID
@property (nonatomic, copy, nullable) NSString *name;   //部门名

@end



@interface CreatePartResponseData : BaseResponseData

@property (nonatomic, copy, nullable) NSString *did;    //部门ID

@end
