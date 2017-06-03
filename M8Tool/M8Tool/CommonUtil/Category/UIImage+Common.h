//
//  UIImage+Common.h
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/11/9.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 图片裁剪

 @param image   原始图片
 @param size    裁剪后的大小
 @return        裁剪后的图片
 */
+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size ;

@end
