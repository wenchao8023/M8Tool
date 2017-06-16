//
//  M8FloatWindowSingleton.h
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "M8CallBaseViewController.h"

typedef void(^CallBack)();

@class M8FloatWindowController;
@interface M8FloatWindowSingleton : NSObject

@property (nonatomic, strong, nullable) M8FloatWindowController *floatVC;
@property (nonatomic, copy, nullable) CallBack floatWindowCallBack;



+ (nonnull instancetype)Instance;

- (void)M8_addWindowOnTarget: (nonnull id)target onClick:(nullable void(^)())callback;

- (void)M8_setRenderViewCall:(TILMultiCall *_Nonnull)call identify:(NSString *_Nonnull)identify;


@end
