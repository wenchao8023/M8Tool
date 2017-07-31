//
//  M8AlertWindow.m
//  M8Tool
//
//  Created by chao on 2017/7/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8AlertWindow.h"


@interface M8AlertWindow ()
{
    CGRect _curFrame;
}

@property (weak, nonatomic) IBOutlet UILabel *alertTitle;

@property (weak, nonatomic) IBOutlet UILabel *alertInfo;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end


@implementation M8AlertWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _curFrame = frame;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.frame = _curFrame;
}





@end
