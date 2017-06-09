//
//  M8CallVideoNoteView.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallVideoNoteView.h"


@interface M8CallVideoNoteView ()
{
    CGRect _myFrame;
}



@end



@implementation M8CallVideoNoteView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        _myFrame = frame;
        //        self.backgroundColor = WCCyan;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}


@end
