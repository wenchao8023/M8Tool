//
//  ReportCallMemRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface ReportCallMemRequest : BaseRequest

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) NSInteger mid;
//@property (nonatomic, assign) NSInteger statu;   //状态 默认是0：0:未响应，1:接受，2:拒绝
@property (nonatomic, assign) NSString *statu;

@end
