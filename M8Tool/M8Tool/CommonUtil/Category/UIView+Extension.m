//
//  UIView+Extension.m
//  SinaWeibo
//
//  Created by chensir on 15/10/13.
//  Copyright (c) 2015年 ZT. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setBorder_top_color:(UIColor *)color width:(CGFloat)width
{
    [self setBorder_top:YES
                   left:NO
                 bottom:NO
                  right:NO
            borderColor:color borderWidth:width];
}
- (void)setBorder_left_color:(UIColor *)color width:(CGFloat)width
{
    [self setBorder_top:NO
                   left:YES
                 bottom:NO
                  right:NO
            borderColor:color borderWidth:width];
}
- (void)setBorder_bottom_color:(UIColor *)color width:(CGFloat)width
{
    [self setBorder_top:NO
                   left:NO
                 bottom:YES
                  right:NO
            borderColor:color borderWidth:width];
}
- (void)setBorder_right_color:(UIColor *)color width:(CGFloat)width
{
    [self setBorder_top:NO
                   left:NO
                 bottom:NO
                  right:YES
            borderColor:color borderWidth:width];
}

- (void)setBorder_top:(BOOL)top
                 left:(BOOL)left
               bottom:(BOOL)bottom
                right:(BOOL)right
          borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.height - width, self.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.width - width, 0, width, self.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}

@end
