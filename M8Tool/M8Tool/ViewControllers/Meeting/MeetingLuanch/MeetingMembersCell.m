//
//  MeetingMembersCell.m
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingMembersCell.h"



@interface MeetingMembersCell ()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *delImg;   // 显示正在删除的元素 - meeting
@property (weak, nonatomic) IBOutlet UIImageView *actionImg;

@end


@implementation MeetingMembersCell


#pragma mark - 配置 参会人员
- (void)configMeetingMembersWithNameStr:(NSString *)nameStr isDeling:(BOOL)isDeling
{
    self.actionImg.hidden = YES;
    self.nameLabel.hidden = NO;
    self.delImg.hidden = !isDeling;
    
    // 设置Label圆形
    WCViewBorder_Radius(self.nameLabel, self.nameLabel.width / 2);
    
    [self.nameLabel setAttributedText:[CommonUtil customAttString:[nameStr getSimpleName]
                                                         fontSize:kAppMiddleFontSize
                                                        textColor:WCButtonColor
                                                        charSpace:kAppKern_0]
     ];
    self.nameLabel.backgroundColor = WCCollectMemberColor;
    self.nameLabel.textColor = WCButtonColor;
}
//设置添加和删除两个按钮图片
- (void)configMeetingMembersWithImageStr:(NSString *)imageStr
{
    self.delImg.hidden = YES;
    self.nameLabel.hidden = YES;
    self.actionImg.hidden = NO;
    self.actionImg.image = kGetImage(imageStr);
}

#pragma mark - 配置 最近联系人
- (void)configLatestMembersWithNameStr:(NSString *)nameStr isSelected:(BOOL)isSelected radiusBorder:(CGFloat)radius
{
    
    // 设置Label圆形
    WCViewBorder_Radius(self.nameLabel, radius);
    
    self.actionImg.hidden = YES;
    self.delImg.hidden = YES;
    self.nameLabel.hidden = NO;
    
    [self.nameLabel setAttributedText:[CommonUtil customAttString:[nameStr getSimpleName]
                                                         fontSize:kAppMiddleFontSize
                                                        textColor:nil
                                                        charSpace:kAppKern_0]
     ];
    
    if (isSelected)
    {
        self.nameLabel.backgroundColor = WCButtonColor;
        self.nameLabel.textColor = WCCollectMemberColor;
    }
    else
    {
        self.nameLabel.backgroundColor = WCCollectMemberColor;
        self.nameLabel.textColor = WCButtonColor;
    }
}

#pragma mark - 配置 会议详情
- (void)configRecordDetailWithNameStr:(NSString *)nameStr  radiusBorder:(CGFloat)radius
{
    [self configLatestMembersWithNameStr:nameStr isSelected:NO radiusBorder:radius];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

@end
