//
//  M8LuanchTableViewHeader.m
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LuanchTableViewHeader.h"

@implementation M8LuanchTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image
{
    if (self = [super initWithFrame:frame])
    {
        self.image = [UIImage imageNamed:image];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
