//
//  M8MakeCallViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallBaseViewController.h"

@interface M8MakeCallViewController : M8CallBaseViewController

@property (nonatomic, strong, nullable) NSArray *membersArray;

@property (nonatomic, assign) int callId;

@property (nonatomic, assign) TILCallType callType;

@end
