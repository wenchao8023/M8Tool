//
//  UsrContactFriendCell.m
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactFriendCell.h"



@interface UsrContactFriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end




@implementation UsrContactFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 配置群组列表
 */
- (void)configWithItem:(NSString *)itemImg itemText:(NSString *)itemText
{
    [self hiddeXibViews:YES];
    
//    UIImageView *iconImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(10, 10, 40, 40) ImageName:itemImg];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    iconImg.image = [UIImage imageWithColor:WCBlue];
    [self.contentView addSubview:iconImg];
    
    UILabel *titleLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(60, 10, self.width - 70, 40) Text:itemText];
    [self.contentView addSubview:titleLabel];
}


/**
 配置好友列表
 */
- (void)configWithFriendItem
{
    [self hiddeXibViews:NO];
}


- (void)hiddeXibViews:(BOOL)hidden
{
    self.iconLabel.hidden = hidden;
    self.titleLabel.hidden = hidden;
    self.subTitleLabel.hidden = hidden;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
