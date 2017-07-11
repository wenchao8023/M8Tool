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
    if ([model.type isEqualToString:@"live"])
    {
        [self.callTypeImg setImage:kGetImage(@"record_callType_live")];
    }
    if ([model.type isEqualToString:@"call_audio"])
    {
        [self.callTypeImg setImage:kGetImage(@"record_callType_audio")];
    }
    if ([model.type isEqualToString:@"call_video"])
    {
        [self.callTypeImg setImage:kGetImage(@"record_callType_video")];
    }
    
    if ([model.mainuser isEqualToString:[[ILiveLoginManager getInstance] getLoginId]])
    {
        self.luancherLaber.text = [NSString stringWithFormat:@"我(%lu人)", model.members.count];
    }
    else
    {
        self.luancherLaber.text = [NSString stringWithFormat:@"%@(%lu人)", model.mainuser, model.members.count];
    }
    
    NSMutableString *membersStr = [[NSMutableString alloc] initWithCapacity:0];
    for (M8MeetMemberInfo *info in model.members)
    {
        if ([info isEqual:[model.members lastObject]])
        {
            [membersStr appendString:[NSString stringWithFormat:@"%@", info.user]];
        }
        else
        {
            [membersStr appendString:[NSString stringWithFormat:@"%@,", info.user]];
        }
        
    }
    self.membersLabel.text = membersStr;
    self.timeLabel.text = [CommonUtil getDateStrWithTime:[model.starttime doubleValue]];
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
