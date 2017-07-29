//
//  MeetListCollectionViewCell.m
//  M8Tool
//
//  Created by looper on 17/7/22.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetListCollectionViewCell.h"


@interface MeetListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UILabel *host;
@property (weak, nonatomic) IBOutlet UILabel *liveTitle;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;



@end


@implementation MeetListCollectionViewCell



- (void)config:(M8LiveRoomModel *)model
{
    self.host.text = model.uid;
    
    M8LiveRoomInfo *rInfo = model.info;
//    self.coverImg.image = kGetImage(rInfo.cover);
    self.coverImg.image = kGetImage(@"liveDefalutCover.jpeg");
    self.liveTitle.text = rInfo.title;
    self.membersLabel.text = [NSString stringWithFormat:@"%@人", rInfo.memsize];
}


@end
