//
//  M8CallRenderCell.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderCell.h"

static NSString * const kMemberStatu_lineBusy   = @"占线";
static NSString * const kMemberStatu_reject     = @"拒绝";
static NSString * const kMemberStatu_timeout    = @"超时";
static NSString * const kMemberStatu_hangup     = @"挂断";
static NSString * const kMemberStatu_disconnect = @"断开";
static NSString * const kMemberStatu_waiting    = @"连接中";   // 需考虑是否添加此状态



@interface M8CallRenderCell ()

@property (weak, nonatomic) IBOutlet M8LiveLabel *identifyLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (weak, nonatomic) IBOutlet UIImageView *onCloseMicImg;

@property (weak, nonatomic) IBOutlet UIImageView *onVioceImg;

@end


@implementation M8CallRenderCell

- (void)config:(M8CallRenderModel *)model {

    
}

- (void)configWithModel:(M8CallRenderModel *)model {
    
    WCViewBorder_Radius(self.onVioceImg, _onVioceImg.width / 2);
    
    self.identifyLabel.text = model.identify;

    self.infoLabel.hidden = NO;
    
    self.effectView.hidden = NO;
    
    self.onCloseMicImg.hidden = YES;
    self.onVioceImg.hidden    = YES;
    
    
    switch (model.meetMemberStatus) {
        case MeetMemberStatus_linebusy:
        {
            self.infoLabel.text = kMemberStatu_lineBusy;
        }
            break;
        case MeetMemberStatus_reject:
        {
            self.infoLabel.text = kMemberStatu_reject;
        }
            break;
        case MeetMemberStatus_timeout:
        {
            self.infoLabel.text = kMemberStatu_timeout;
        }
            break;
        case MeetMemberStatus_receive:
        {
            self.infoLabel.hidden = YES;
            if (model.isCameraOn) {
                self.effectView.hidden = YES;
                
                if (!model.isMicOn) {
                    self.onCloseMicImg.hidden = NO;
                }
            }
            else {
                self.onVioceImg.hidden = NO;
                [self.onVioceImg setImage:[UIImage imageNamed:(model.isMicOn ? @"liveAudio_on" : @"liveAudio_off")]];
            }
        }
            break;
        case MeetMemberStatus_hangup:
        {
            self.infoLabel.text = kMemberStatu_hangup;
        }
            break;
        case MeetMemberStatus_disconnect:
        {
            self.infoLabel.text = kMemberStatu_disconnect;
        }
            break;
            
        default:
            break;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.identifyLabel configLiveRenderText];
    [self.infoLabel configLiveRenderText];
}

@end
