//
//  UsrContactHeaderView.m
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactHeaderView.h"

@interface UsrContactHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *membersLabel;

@end


@implementation UsrContactHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (void)configWithTitle:(NSString *)titleStr friendsNum:(long)friendsNum {
    self.titleLabel.text = @"深圳市音飙科技有限公司";
    self.membersLabel.text = [NSString stringWithFormat:@"%ld人", friendsNum];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
