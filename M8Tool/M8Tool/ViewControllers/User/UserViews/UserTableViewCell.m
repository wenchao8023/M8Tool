//
//  UserTableViewCell.m
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserTableViewCell.h"


@interface UserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation UserTableViewCell

- (void)config:(UserTableViewModel *)model {
    self.iconImage.image = [UIImage imageNamed:model.imgStr];
    
    [self.titleLabel setAttributedText:[CommonUtil customAttString:model.titleStr fontSize:kAppMiddleFontSize textColor:WCBlack charSpace:kAppKern_2]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
