//
//  MeetingLuanchTableViewCell.m
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchTableViewCell.h"


@interface MeetingLuanchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *MeetingItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *MeetingContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MeetingIconImage;

@end



@implementation MeetingLuanchTableViewCell

- (void)configWithItem:(NSString *)item content:(NSString *)content imageName:(NSString *)imageName {
    self.MeetingItemLabel.text = item;
    self.MeetingContentLabel.text = content;
    if (imageName &&
        imageName.length)
        self.MeetingIconImage.image = [UIImage imageNamed:imageName];
    else
        self.MeetingIconImage.hidden = YES;
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
