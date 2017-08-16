//
//  M8UploadImageHelper.h
//  M8Tool
//
//  Created by chao on 2017/6/30.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8UploadImageHelper : NSObject

+ (instancetype)shareInstance;

- (void)upload:(UIImage *)image completion:(void (^)(NSString *imageSaveUrl))completion failed:(void (^)(NSString *failTip))failure;

@end
