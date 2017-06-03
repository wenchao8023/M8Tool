//
//  UIView+Extension.h
//  SinaWeibo
//
//  Created by chensir on 15/10/13.
//  Copyright (c) 2015年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;


- (void)setBorder_top_color:(UIColor *)color
                      width:(CGFloat)width ;
- (void)setBorder_left_color:(UIColor *)color
                       width:(CGFloat)width ;
- (void)setBorder_bottom_color:(UIColor *)color
                         width:(CGFloat)width ;
- (void)setBorder_right_color:(UIColor *)color
                        width:(CGFloat)width ;
- (void)setBorder_top:(BOOL)top
                 left:(BOOL)left
               bottom:(BOOL)bottom
                right:(BOOL)right
          borderColor:(UIColor *)color borderWidth:(CGFloat)width ;

@end
