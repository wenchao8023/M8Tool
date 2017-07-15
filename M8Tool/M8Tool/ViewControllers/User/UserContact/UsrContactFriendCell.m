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


/**
 用于配置第一组item
 */
@property (nonatomic, strong) UIImageView *iconImg;

@property (nonatomic, strong) UILabel *itemTitleLabel;

@end




@implementation UsrContactFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:self.iconImg];
    
    self.itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, self.width - 70, 40)];
    [self.contentView addSubview:self.itemTitleLabel];
}

/**
 配置第一分组里面的项
 */
- (void)configWithItem:(NSString *)itemImg itemText:(NSString *)itemText
{
    [self hiddeXibViews:YES];
    
    self.iconImg.image = [UIImage imageWithColor:WCRed];
    
    self.itemTitleLabel.text = itemText;
}


/**
 配置部门信息
 */
- (void)configWithDepartmentItem:(M8DepartmentInfo *)dInfo
{
    self.backgroundColor = WCClear;
    self.contentView.backgroundColor = WCClear;
    
    [self hiddeXibViews:YES];
    
    self.iconImg.image = [UIImage imageWithColor:WCLightGray];
    
    self.itemTitleLabel.text = dInfo.dname;
}

/**
 配置好友列表
 */
- (void)configWithFriendItem:(M8FriendInfo *)friendInfo
{
    self.backgroundColor = WCClear;
    self.contentView.backgroundColor = WCClear;
    
    [self hiddeXibViews:NO];

    NSDictionary *dic = [friendInfo.SnsProfileItem firstObject];
    NSString *nick = [dic objectForKey:@"Value"];
    NSString *phone = friendInfo.Info_Account;
    
    self.iconLabel.text = [nick getSimpleName];
    self.titleLabel.text = nick;
    self.subTitleLabel.text = phone;
}


- (void)hiddeXibViews:(BOOL)hidden
{
    self.iconLabel.hidden = hidden;
    self.titleLabel.hidden = hidden;
    self.subTitleLabel.hidden = hidden;
    
    self.iconImg.hidden = !hidden;
    self.itemTitleLabel.hidden = !hidden;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
