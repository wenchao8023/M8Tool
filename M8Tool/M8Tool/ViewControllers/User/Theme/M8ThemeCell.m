//
//  M8ThemeCell.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8ThemeCell.h"

@interface M8ThemeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *themeImg;

@property (weak, nonatomic) IBOutlet UILabel *themeName;

    
@end

@implementation M8ThemeCell

- (void)config:(M8ThemeModel *)model {
    self.themeImg.image = [UIImage imageNamed:model.imgStr];
    
    self.themeName.text = model.nameStr;
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
