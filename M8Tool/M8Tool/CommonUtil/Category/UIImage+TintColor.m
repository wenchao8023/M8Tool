//
//  UIImage+TintColor.m
//  TILLiveSDKShow
//
//  Created by wilderliao on 17/1/6.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "UIImage+TintColor.h"

@implementation UIImage (TintColor)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    if (!tintColor) {
        return self;
    }
    
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

-(UIImage *)imageDrawClearRect {
    
    CGSize imgSize = self.size;
    CGFloat drawClearWidth = self.size.width / 44;
    UIGraphicsBeginImageContext(imgSize);
    [self drawInRect:CGRectMake(drawClearWidth, drawClearWidth, imgSize.width - drawClearWidth * 2, imgSize.height - drawClearWidth * 2)];
    UIImage *clearedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clearedImg;
}

@end
