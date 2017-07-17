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
 用于记录 cell 状态的图片
 如果是编辑的时候，将会存放一张可编辑的图片
 如果是选择的时候，将会显示是否选中
 */
@property (weak, nonatomic) IBOutlet UIImageView *statuImg;

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
    NSDictionary *dic = [friendInfo.SnsProfileItem firstObject];

    M8MemberInfo *info = [M8MemberInfo new];
    info.uid    = friendInfo.Info_Account;
    info.nick   = [dic objectForKey:@"Value"];
    [self configWithMemberItem:info];
}


/**
 配置默认状态下的样式
 */
- (void)configWithMemberItem:(M8MemberInfo *)memberInfo
{
    self.backgroundColor = WCClear;
    self.contentView.backgroundColor = WCClear;
    
    [self hiddeXibViews:NO];
    
    self.iconLabel.text = [memberInfo.nick getSimpleName];
    self.titleLabel.text = memberInfo.nick;
    self.subTitleLabel.text = memberInfo.uid;
}

- (void)hiddeXibViews:(BOOL)hidden
{
    self.iconLabel.hidden = hidden;
    self.titleLabel.hidden = hidden;
    self.subTitleLabel.hidden = hidden;
    
    self.iconImg.hidden = !hidden;
    self.itemTitleLabel.hidden = !hidden;
}


/**
 管理员进入，显示编辑图片
 */
- (void)configMemberItemEditing:(M8MemberInfo *)memberInfo
{
    self.statuImg.hidden = NO;
    
    [self configWithMemberItem:memberInfo];
}


- (void)configMemberItem:(id)memberInfo isSelected:(BOOL)selected
{
    self.statuImg.hidden = NO;
    if (selected)
    {
        self.backgroundColor = WCGreen;
        WCViewBorder_Radius(self.statuImg, 10);
    }
    else
    {
        self.backgroundColor = WCClear;
        WCViewBorder_Width_Color(self.statuImg, 2, WCGreen);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
