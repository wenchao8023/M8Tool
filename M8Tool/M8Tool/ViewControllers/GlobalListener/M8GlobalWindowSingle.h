//
//  M8GlobalWindowSingle.h
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8GlobalWindowSingle : NSObject

+ (instancetype _Nullable)shareInstance;
- (void)addAlertInfo:(NSString *_Nullable)alertInfo alertType:(GlobalAlertType)alertType;

@end
