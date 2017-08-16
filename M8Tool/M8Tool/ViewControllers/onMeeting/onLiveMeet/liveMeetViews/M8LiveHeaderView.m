//
//  M8LiveHeaderView.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveHeaderView.h"


@interface M8LiveHeaderView ()
{
    CGRect _myFrame;
}
@end


@implementation M8LiveHeaderView
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

- (IBAction)onAttentionAction:(id)sender
{
    BOOL ret = [M8UserDefault getPushMenuStatu];
    if (ret)
    {
        [WCNotificationCenter postNotificationName:kHiddenMenuView_Notifycation object:nil];
        return ;
    }
    WCLog(@"点击关注");
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
}


@end
