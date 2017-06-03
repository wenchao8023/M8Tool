//
//  LoginManager.h
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LoginType_Succ,
    LoginType_Fail,
    LoginType_Busy,
} LoginType;

typedef void(^LoginTypeBlock)(LoginType type);

@interface LoginManager : NSObject

@property (nonatomic, copy, nullable) LoginTypeBlock loginTypeBlock;

- (void)autoLogin ;

- (void)login:(NSString *_Nonnull)identifier passward:(NSString *_Nonnull)pwd click:(BOOL)isClick ;

@end
