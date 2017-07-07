//
//  M8LiveInfoView.m
//  M8Tool
//
//  Created by chao on 2017/6/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveInfoView.h"


@interface M8LiveInfoView ()


@end

@implementation M8LiveInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = WCClear;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, self.width, self.height);
        effectView.alpha = 0.6;
        [self addSubview:effectView];
    }
    return self;
}

@end
