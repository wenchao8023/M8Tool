//
//  M8GlobalAlert.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalAlert.h"

@interface M8GlobalAlert ()
{
    CGRect _curFrame;
}

@property (weak, nonatomic) IBOutlet UILabel *alertTitle;

@property (weak, nonatomic) IBOutlet UILabel *alertInfo;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;



@end

@implementation M8GlobalAlert

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    WCViewBorder_Radius(self, 4);
    
    [self.leftButton setBorder_top_color:WCButtonColor width:0.5];
    [self.leftButton setBorder_right_color:WCButtonColor width:0.5];
    [self.rightButton setBorder_top_color:WCButtonColor width:0.5];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _curFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.frame = _curFrame;
}


@end
