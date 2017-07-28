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
    
    self.iconImg.image = [UIImage imageNamed:itemImg];
    
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
    
    self.statuImg.hidden = YES; //默认会设置成 隐藏，如果需要显示请自行设置
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
    [self configWithMemberItem:memberInfo];
    
    self.statuImg.hidden = NO;
}


/**
 配置选人的状态
 */
- (void)configMemberItem:(id)memberInfo isSelected:(BOOL)selected
{
    [self configWithMemberItem:memberInfo];
    
    self.statuImg.hidden = NO;
    if (selected)
    {
        self.statuImg.backgroundColor = WCGreen;
        WCViewBorder_Radius(self.statuImg, 10);
    }
    else
    {
        self.statuImg.backgroundColor = WCClear; 
        WCViewBorder_Radius_Width_Color(self.statuImg, 10, 2, WCGreen);
    }
}

/**
 配置管理者进入，- 不可反选样式
 */
- (void)configMemberitemUnableUnselect:(M8MemberInfo *)info
{
    [self configWithMemberItem:info];
    
    self.statuImg.hidden = NO;
    
    self.statuImg.backgroundColor = WCGray;
    WCViewBorder_Radius(self.statuImg, 10);
    
    self.userInteractionEnabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
