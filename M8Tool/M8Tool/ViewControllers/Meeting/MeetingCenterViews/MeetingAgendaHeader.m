//
//  MeetingAgendaHeader.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingAgendaHeader.h"

@interface MeetingAgendaHeader()
{
    CGRect _myFrame;
}

@end


@implementation MeetingAgendaHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.frame = _myFrame;
}
- (IBAction)onMoreAgendaAction:(id)sender
{
    if (self.onMoreAgendaActionBlock)
    {
        self.onMoreAgendaActionBlock();
    }
}


@end
