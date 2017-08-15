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

@property (weak, nonatomic) IBOutlet UILabel *friendTipLabel;


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
    
    self.iconImg.image = [UIImage imageNamed:@"user_department"];
    
    self.itemTitleLabel.text = dInfo.dname;
}



/**
 管理员进入，显示编辑图片
 */
- (void)configMemberItemEditing:(M8MemberInfo *)memberInfo
{
    [self configWithDefalutItem:memberInfo];
    
    self.statuImg.hidden = NO;
}


/**
 配置选人的状态
 */
- (void)configMemberItem:(id)memberInfo isSelected:(BOOL)selected
{
    [self configWithDefalutItem:memberInfo];
    
    self.statuImg.hidden = NO;
    if (selected)
    {
        self.statuImg.image = kGetImage(@"user_selected");
    }
    else
    {
        self.statuImg.image = kGetImage(@"user_unSelect");
    }
}

/**
 配置管理者进入，- 不可反选样式
 */
- (void)configMemberitemUnableUnselect:(M8MemberInfo *)info
{
    [self configWithDefalutItem:info];
    
    self.statuImg.hidden = NO;

    self.statuImg.image = kGetImage(@"user_unableSelect");
    
    self.userInteractionEnabled = NO;
}


/**
 配置好友列表
 */
- (void)configWithFriendItem:(M8MemberInfo *)info
{
    [self configWithDefalutItem:info];
}

/**
 配置默认状态下的样式
 */
- (void)configWithDefalutItem:(M8MemberInfo *)info
{
    self.backgroundColor = WCClear;
    self.contentView.backgroundColor = WCClear;
    
    [self hiddeXibViews:NO];
    
    [self.iconLabel setAttributedText:[[NSAttributedString alloc] initWithString:[info.nick getSimpleName]
                                                                      attributes:[CommonUtil customAttsWithBodyFontSize:kAppMiddleFontSize
                                                                                                              textColor:WCWhite]]];
    [self.titleLabel setAttributedText:[CommonUtil customAttString:info.nick]];
    [self.subTitleLabel setAttributedText:[CommonUtil customAttString:info.uid fontSize:kAppSmallFontSize]];
    
    self.friendTipLabel.hidden = YES;
    if ([M8UserDefault getNewFriendNotify])
    {
        NSArray *newFriendArr = [M8UserDefault getNewFriendIdentify];
        if (newFriendArr)
        {
            if ([newFriendArr containsObject:info.uid])
            {
                self.friendTipLabel.hidden = NO;
            }
        }
    }
    
    self.statuImg.hidden = YES; //默认会设置成 隐藏，如果需要显示请自行设置
}


/**
 隐藏xib中的views
 */
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
