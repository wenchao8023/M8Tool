//
//  M8CallRenderNote.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderNote.h"


@interface M8CallRenderNote ()<UITextViewDelegate>
{
    CGRect _myFrame;
}



@end



@implementation M8CallRenderNote
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
