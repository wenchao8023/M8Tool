//
//  M8GlobalNetTipView.m
//  M8Tool
//
//  Created by chao on 2017/8/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalNetTipView.h"

#import "M8GlobalNetDesViewController.h"


@interface M8GlobalNetTipView ()
{
    CGRect _curFrame;
}

@end

@implementation M8GlobalNetTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _curFrame = frame;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.frame = _curFrame;
}


- (IBAction)onNetTipAction:(id)sender
{
    M8GlobalNetDesViewController *desVC = [[M8GlobalNetDesViewController alloc] init];
    desVC.isExitLeftItem = YES;
    [[AppDelegate sharedAppDelegate] pushViewControllerWithBottomBarHidden:desVC];
}


@end
