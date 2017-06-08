//
//  M8MeetRenderCell.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRenderCell.h"


@interface M8MeetRenderCell ()

@property (weak, nonatomic) IBOutlet UILabel *testLabel;



@end

@implementation M8MeetRenderCell

- (void)config:(M8MeetRenderModel *)model {
    if (model.isCameraOn) {
        TILLiveManager *manager = [TILLiveManager getInstance];
        [manager addAVRenderView:self.contentView.bounds forIdentifier:model.identify srcType:model.videoScrType];
    }
    
    self.testLabel.text = model.identify;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
