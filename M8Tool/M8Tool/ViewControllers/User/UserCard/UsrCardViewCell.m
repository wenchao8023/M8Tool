//
//  UsrCardViewCell.m
//  M8Tool
//
//  Created by chao on 2017/5/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrCardViewCell.h"

@interface UsrCardViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation UsrCardViewCell


- (void)config:(NSString *)imageStr item:(NSString *)itemStr {
    self.iconImage.image = [UIImage imageNamed:imageStr];
    
    [self.itemLabel setAttributedText:[CommonUtil customAttString:itemStr
                                                         fontSize:kAppMiddleFontSize
                                                        textColor:WCBlack
                                                        charSpace:kAppKern_2]];
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
