//
//  M8LiveNoteView.m
//  M8Tool
//
//  Created by chao on 2017/6/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveNoteView.h"

@interface M8LiveNoteView ()<UITextViewDelegate>
{
    CGRect _myFrame;
}
@end

@implementation M8LiveNoteView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:kPushMenuStatus];
    if (ret)
    {
        [WCNotificationCenter postNotificationName:kHiddenMenuView_Notifycation object:nil];
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
}

@end
