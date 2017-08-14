//
//  M8MeetRecordCell.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRecordCell.h"

#import "M8MeetRecordModel.h"

@interface M8MeetRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *luancherLaber;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *callTypeImg;

@property (weak, nonatomic) IBOutlet UILabel *isCollectLabel;


@end

@implementation M8MeetRecordCell

- (void)config:(M8MeetRecordModel *)model {
    //通话类型图片
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
    
    NSAttributedString *luancherAttText = nil;
    //通话发起人+人数
    if ([model.mainuser isEqualToString:[M8UserDefault getLoginId]])
    {
        luancherAttText = [CommonUtil customAttString:[NSString stringWithFormat:@"我(%lu人)", model.members.count]];
//        self.luancherLaber.text = [NSString stringWithFormat:@"我(%lu人)", model.members.count];
    }
    else
    {
        for (M8MeetMemberInfo *info  in model.members)
        {
            if ([info.user isEqualToString:model.mainuser])
            {
                luancherAttText = [CommonUtil customAttString:[NSString stringWithFormat:@"%@(%lu人)", info.nick, model.members.count]];
//                self.luancherLaber.text = [NSString stringWithFormat:@"%@(%lu人)", info.nick, model.members.count];
                break;
            }
        }
    }
    
    [self.luancherLaber setAttributedText:luancherAttText];
    
    
    
    //通话时间
//    self.timeLabel.text = [CommonUtil getRecordDateStr:[model.starttime doubleValue]];
    [self.timeLabel setAttributedText:[CommonUtil customAttString:[CommonUtil getRecordDateStr:[model.starttime doubleValue]]]];
    
    //通话成员
    NSMutableString *membersStr = [[NSMutableString alloc] initWithCapacity:0];
    for (M8MeetMemberInfo *info in model.members)
    {
        if ([info isEqual:[model.members lastObject]])
        {
            [membersStr appendString:[NSString stringWithFormat:@"%@", info.nick]];
        }
        else
        {
            [membersStr appendString:[NSString stringWithFormat:@"%@,", info.nick]];
        }
    }
//    self.membersLabel.text = membersStr;
    [self.membersLabel setAttributedText:[CommonUtil customAttString:membersStr]];
    
    //是否有收藏
    self.isCollectLabel.hidden = !model.collect;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    WCViewBorder_Radius_Width_Color(self.isCollectLabel, 2, 1, WCLightGray);
}

@end
