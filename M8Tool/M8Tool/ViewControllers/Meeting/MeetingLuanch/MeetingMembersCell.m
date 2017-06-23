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

@property (weak, nonatomic) IBOutlet UIImageView *actionImg;

@property (weak, nonatomic) IBOutlet UIImageView *delImg;   // 显示正在删除的元素 - meeting

@property (weak, nonatomic) IBOutlet UIImageView *selImg;   // 显示元素选中状态 - latest


@end



@implementation MeetingMembersCell


#pragma mark - 配置 参会人员
- (void)configMeetingMembersWithNameStr:(NSString *)nameStr isDeling:(BOOL)isDeling {
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.92 blue:0.85 alpha:1];
    [self setNameHidden:NO];
    self.delImg.hidden = !isDeling;
    [self.nameLabel setAttributedText:[CommonUtil customAttString:nameStr
                                                         fontSize:kAppMiddleFontSize
                                                        textColor:WCButtonColor
                                                        charSpace:kAppKern_0]
     ];
}

- (void)configMeetingMembersWithImageStr:(NSString *)imageStr {
    self.backgroundColor = WCClear;
    [self setNameHidden:YES];
    self.delImg.hidden = YES;
    self.actionImg.image = [UIImage imageNamed:imageStr];
    
}

- (void)setNameHidden:(BOOL)hidden {
    self.selImg.hidden      = YES;
    self.nameLabel.hidden   = hidden;
    self.actionImg.hidden   = !hidden;
}

#pragma mark - 配置 最近联系人
- (void)configLatestMembersWithNameStr:(NSString *)nameStr isSelected:(BOOL)isSelected {
    self.actionImg.hidden   = YES;
    self.delImg.hidden      = YES;
    
    [self.nameLabel setAttributedText:[CommonUtil customAttString:nameStr
                                                         fontSize:kAppMiddleFontSize
                                                        textColor:WCButtonColor
                                                        charSpace:kAppKern_0]
     ];
    
    self.selImg.backgroundColor = isSelected ? WCButtonColor : WCWhite;
}


#pragma mark - 配置 会议详情
- (void)configRecordDetailWithNameStr:(NSString *)nameStr {
    [self configLatestMembersWithNameStr:nameStr isSelected:NO];
    self.selImg.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.92 blue:0.85 alpha:1];
}

@end
