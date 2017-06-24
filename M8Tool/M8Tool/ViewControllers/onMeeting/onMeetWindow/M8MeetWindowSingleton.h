//
//  M8MeetWindowSingleton.h
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M8MeetWindowSingleton : NSObject


+ (instancetype)getInstance;

- (void)addCallSource:(id _Nonnull)source WindowOnTarget:(UIViewController *_Nonnull)target;
- (void)addLiveSource:(id _Nonnull)source WindowOnTarget:(UIViewController *_Nonnull)target;
- (void)showFloatView;
- (void)hiddeFloatView;


@end
