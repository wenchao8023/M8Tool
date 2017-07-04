//
//  MMeetWindowSingleton.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMeetWindowSingleton : NSObject

+ (instancetype _Nonnull )shareInstance;


/**
 添加视图控制器到 window 的根视图
 
 @param source 会议视图控制器
 */
- (void)addMeetSource:(id _Nonnull)source;

@end
