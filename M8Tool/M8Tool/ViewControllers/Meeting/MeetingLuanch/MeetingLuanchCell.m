//
//  MeetingLuanchCell.m
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingLuanchCell.h"

#import "RecordModel.h"


@interface MeetingLuanchCell ()

@property (weak, nonatomic) IBOutlet UILabel *MeetingItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *MeetingContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MeetingIconImage;

@end



@implementation MeetingLuanchCell

- (void)configWithTageArray:(NSArray *)tagsArray {
    
    self.MeetingItemLabel.hidden = YES;
    self.MeetingContentLabel.hidden = YES;
    self.MeetingIconImage.hidden = YES;
    
    UILabel *topLineLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(0, 0, self.width, 0.6) BgColor:WCDarkGray];
    [self.contentView addSubview:topLineLabel];
    
    UILabel *bottomLineLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(0, kDefaultCellHeight - 0.6, self.width, 0.6) BgColor:WCDarkGray];
    [self.contentView addSubview:bottomLineLabel];
    
    
    UIImageView *tagImg = [WCUIKitControl createImageViewWithFrame:CGRectMake(10, 7, 20, 30) ImageName:@""];
    [self.contentView addSubview:tagImg];
    
    
    UILabel *tagsLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(50, 10, self.width - 50, 24) Text:[tagsArray componentsJoinedByString:@","]];
    [self.contentView addSubview:tagsLabel];
}

- (void)configWithItem:(NSString *)item content:(NSString *)content {
    self.MeetingContentLabel.textAlignment = 0;
    [self configWithItem:item content:content imageName:nil];
}

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
