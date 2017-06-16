//
//  M8MeetWindowSingleton.h
//  M8Tool
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>



@class M8CallBaseViewController;
@interface M8MeetWindowSingleton : NSObject

@property (nonatomic, strong, nullable) M8CallBaseViewController *callViewController;

+ (instancetype)getInstance;

- (void)addSource:(M8CallBaseViewController * _Nonnull)source WindowOnTarget:(UIViewController *_Nonnull)target;
- (void)showFloatView;
- (void)hiddeFloatView;


@end
