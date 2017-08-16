//
//  M8LiveJoinCell.m
//  M8Tool
//
//  Created by chao on 2017/6/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveJoinCell.h"


@interface M8LiveJoinCell ()

@property (nonatomic, strong) UILabel *testLabel;

@end


@implementation M8LiveJoinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addOwnViews];
        self.contentView.backgroundColor = WCOrange;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addOwnViews {
    _testLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(100, 100, 100, 100) Text:nil];
    [self.contentView addSubview:_testLabel];
}

- (void)configWithNumStr:(NSString *)numStr isVisible:(BOOL)isvis {
    _testLabel.text = numStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
