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
@property (nonatomic, assign) NSString *statu;

@end
