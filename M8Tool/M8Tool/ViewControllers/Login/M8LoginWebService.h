//
//  M8LoginWebService.h
//  M8Tool
//
//  Created by chao on 2017/6/30.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^M8LoginHandle)(NSString *_Nonnull loginInfo);

@interface M8LoginWebService : NSObject
{
    @protected
    M8LoginHandle _succHandle;
    M8LoginHandle _failHandle;
}


- (void)M8LoginWithIdentifier:(NSString *_Nonnull)identifier password:(NSString *_Nonnull)password succ:(M8LoginHandle _Nullable )succHandle fail:(M8LoginHandle _Nullable )failHandle;

@end
