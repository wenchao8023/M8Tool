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




@end

@implementation M8MeetRenderCell

- (void)config:(M8MeetRenderModel *)model {

    
}

- (void)configCall:(TILMultiCall *)call model:(M8MeetRenderModel *)model {
    
    self.identifyLabel.text = model.identify;
    self.onVioceImg.hidden = model.isCameraOn;
    
    if (model.isCameraOn) {
        [call modifyRenderView:self.contentView.bounds forIdentifier:model.identify];
        ILiveRenderView *renderView = [call getRenderFor:model.identify];
        self.backgroundView = renderView;
        
        self.onCloseMicImg.hidden = model.isMicOn;
    }
    else {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.contentView.bounds;
        effectView.alpha = 0.8;
        self.backgroundView = effectView;
        
        self.onCloseMicImg.hidden = YES;
        
        
        [self.onVioceImg setImage:[UIImage imageNamed:(model.isMicOn ? @"语音开" : @"语音光")]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    WCViewBorder_Radius(self.onVioceImg, self.width / 4);
}

@end
