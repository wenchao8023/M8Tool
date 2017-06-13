//
//  M8MeetRenderCell.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRenderCell.h"


@interface M8MeetRenderCell ()


@property (weak, nonatomic) IBOutlet UIImageView *onCloseMicImg;


@property (weak, nonatomic) IBOutlet UIImageView *onVioceImg;


@property (weak, nonatomic) IBOutlet UILabel *identifyLabel;


@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;


@end

@implementation M8MeetRenderCell

- (void)config:(M8MeetRenderModel *)model {

    
}

- (void)configWithModel:(M8MeetRenderModel *)model {
    
    WCViewBorder_Radius(self.onVioceImg, _onVioceImg.width / 2);
    
    self.identifyLabel.text = model.identify;
    self.onVioceImg.hidden = model.isCameraOn;
    self.effectView.hidden = model.isCameraOn;
    
    if (model.isCameraOn) {
        self.onCloseMicImg.hidden = model.isMicOn;
    }
    else {
        self.onCloseMicImg.hidden = YES;
        
        [self.onVioceImg setImage:[UIImage imageNamed:(model.isMicOn ? @"语音开" : @"语音光")]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
