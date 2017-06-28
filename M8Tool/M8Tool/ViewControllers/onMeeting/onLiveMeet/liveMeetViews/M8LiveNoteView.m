//
//  M8LiveNoteView.m
//  M8Tool
//
//  Created by chao on 2017/6/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveNoteView.h"

@interface M8LiveNoteView ()
{
    CGRect _myFrame;
}
@end

@implementation M8LiveNoteView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
        self.textView.scrollEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}

@end
