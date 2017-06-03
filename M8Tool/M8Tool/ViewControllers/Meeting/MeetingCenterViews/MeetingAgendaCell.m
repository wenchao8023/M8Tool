//
//  MeetingAgendaCell.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingAgendaCell.h"

@interface MeetingAgendaCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthScale;

@end

@implementation MeetingAgendaCell

- (void)configWithTitle:(NSString *)title imageStr:(NSString *)imageStr {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title attributes:[CommonUtil customAttsWithBodyFontSize:kAppLargeFontSize textColor:[UIColor colorWithRed:0.95 green:0.24 blue:0.21 alpha:1]]];
    
    
    [self.timeLabel setAttributedText: attString];

    
    

//    self.iconImage.image = [UIImage imageNamed:imageStr];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (iPhone5SE)
        _iconWidthScale.constant = 0.8;
    else
        _iconWidthScale.constant = 0.6;
    
    [self layoutSubviews];
}

@end
