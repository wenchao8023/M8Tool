//
//  MeetingLuanchCell.m
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchCell.h"

#import "M8MeetListModel.h"


@interface MeetingLuanchCell ()

@property (weak, nonatomic) IBOutlet UILabel *MeetingItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *MeetingContentLabel;

@property (weak, nonatomic) IBOutlet UIButton *meetingCollectBtn;


@end



@implementation MeetingLuanchCell

- (void)configWithTageArray:(NSArray *)tagsArray
{
    self.MeetingItemLabel.hidden    = YES;
    self.MeetingContentLabel.hidden = YES;
    self.meetingCollectBtn.hidden   = YES;
    
    UILabel *topLineLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(0, 0, self.width, 0.6) BgColor:WCDarkGray];
    [self.contentView addSubview:topLineLabel];
    
    UILabel *bottomLineLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(0, kDefaultCellHeight - 0.6, self.width, 0.6) BgColor:WCDarkGray];
    [self.contentView addSubview:bottomLineLabel];
    
    UIImageView *tagImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(10, 7, 30, 30) ImageName:@"collectTag_blue"];
    [self.contentView addSubview:tagImg];
    
    UILabel *tagsLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(50, 10, self.width - 50, 24) Text:[tagsArray componentsJoinedByString:@","]];
    [self.contentView addSubview:tagsLabel];
}

//配置会议详情中的第一个item 判断是否收藏
- (void)configWithItem:(NSString *)item content:(NSString *)content isCollect:(BOOL)isCollect
{
    [self configWithItem:item content:content];
    
    self.meetingCollectBtn.hidden = NO;
    [self.meetingCollectBtn setTitle:(isCollect ? @"已收藏" : @"收藏") forState:UIControlStateNormal];
    WCViewBorder_Radius_Width_Color(self.meetingCollectBtn, 2, 1, WCGray);
}


- (void)configWithItem:(NSString *)item content:(NSString *)content
{
    self.meetingCollectBtn.hidden = YES;
    
    self.MeetingItemLabel.text = item;
    self.MeetingContentLabel.text = content;
}


- (IBAction)onCollectMeetingAction:(id)sender
{
    if ([self.meetingCollectBtn.titleLabel.text isEqualToString:@"收藏"])
    {
        if (self.onCollectMeetBlock)
        {
            self.onCollectMeetBlock();
        }
    }
    
    if ([self.meetingCollectBtn.titleLabel.text isEqualToString:@"已收藏"])
    {
        if (self.onCancelMeetBlock)
        {
            self.onCancelMeetBlock();
        }
    }
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
