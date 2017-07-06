//
//  ReportMemExitRequest.h
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseRequest.h"

@interface ReportMemExitRequest : BaseRequest

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) NSInteger mid;

@end
