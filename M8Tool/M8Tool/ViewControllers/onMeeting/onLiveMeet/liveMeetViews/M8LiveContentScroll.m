//
//  M8LiveContentScroll.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveContentScroll.h"



/**
 设置一个蒙版：是一个颜色、或者是一个图片
 */
@interface SecondBackView : UIView

@end

@implementation SecondBackView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WCLightGray;
    }
    return self;
}
@end



@implementation M8LiveContentScroll

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WCClear;
        self.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT);
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self createUI];
    }
    return self;
}


/**
 将界面设置在第二页上
 */
- (void)createUI {
    
    // 设置第二页的蒙版
    SecondBackView *backView = [[SecondBackView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self addSubview:backView];
}


@end
