//
//  UsrCardViewCell.m
//  M8Tool
//
//  Created by chao on 2017/5/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrCardViewCell.h"

@interface UsrCardViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemWidth;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@end

@implementation UsrCardViewCell

- (void)config:(UserCardModel *)model isFirstItem:(BOOL)isFirstItem isLastItem:(BOOL)isLastItem {
    [self.itemLabel setAttributedText:[CommonUtil customAttString:model.itemStr
                                                         fontSize:kAppMiddleFontSize + 1
                                                        textColor:WCBlack
                                                        charSpace:kAppKern_2]];
    
    [self.contentLabel setAttributedText:[CommonUtil customAttString:model.contentStr
                                                            fontSize:kAppMiddleFontSize
                                                           textColor:WCDarkGray
                                                           charSpace:kAppKern_2]];
    
    _itemWidth.constant = isLastItem ? 100 : 50;
    
    _iconImage.hidden = !isFirstItem;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
