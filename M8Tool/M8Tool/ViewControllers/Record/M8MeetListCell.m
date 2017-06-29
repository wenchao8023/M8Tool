//
//  M8MeetListCell.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListCell.h"

#import "M8MeetListModel.h"

@interface M8MeetListCell()

@property (weak, nonatomic) IBOutlet UILabel *luancherLaber;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *callTypeImg;



@end

@implementation M8MeetListCell

- (void)config:(M8MeetListModel *)model {
    [self.callTypeImg setImage:kGetImage(model.recordType)];
    self.luancherLaber.text = [NSString stringWithFormat:@"%@(%ld人)", model.recordLuancher, [model.recordMembers count]];
    self.membersLabel.text  = [model.recordMembers componentsJoinedByString:@","];
    self.timeLabel.text     = model.recordTime;
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