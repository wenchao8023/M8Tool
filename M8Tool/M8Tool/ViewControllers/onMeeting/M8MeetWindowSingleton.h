//
//  M8MeetWindowSingleton.h
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8MeetWindowSingleton : NSObject

+ (instancetype _Nonnull )shareInstance;

- (void)addMeetSource:(id _Nonnull)source WindowOnTarget:(UIViewController *_Nonnull)target;
- (void)showFloatView;
- (void)hiddeFloatView;

@end
