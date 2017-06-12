//
//  M8MeetHeaderView.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetHeaderView.h"


@interface M8MeetHeaderView ()
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UIButton *enlargeButton;

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;


/**
 这里的两个参数没有必要计算，就算是23：59：59，如果达到小时数的时候，就去掉秒数
 */
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidth_durationLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSpace_topicRight;


@end

@implementation M8MeetHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
        _isLarge = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}


- (IBAction)enlargeAction:(id)sender {
    _isLarge = !_isLarge;
}


@end
