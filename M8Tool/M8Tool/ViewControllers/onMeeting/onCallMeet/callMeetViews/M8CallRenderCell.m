//
//  M8CallRenderCell.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallRenderCell.h"

#import "M8CallRenderModel.h"



@interface M8CallRenderCell ()

@property (weak, nonatomic) IBOutlet M8LiveLabel *identifyLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (weak, nonatomic) IBOutlet UIImageView *onCloseMicImg;

@property (weak, nonatomic) IBOutlet UIImageView *onVioceImg;

@property (nonatomic, strong) M8CallRenderModel *renderModel;

@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIButton *inviteButton;

@end


@implementation M8CallRenderCell

- (void)setButtonsHidden:(BOOL)hidden
{
    self.removeButton.hidden = hidden;
    self.inviteButton.hidden = hidden;
}

- (UIButton *)removeButton
{
    if (!_removeButton)
    {
        CGFloat buttonsHeight = self.height - 15;
        
        CGFloat buttonWidth = (buttonsHeight - 10) / 2;
        CGFloat buttonX = (self.width - buttonWidth) / 2;
        
        UIButton *removeButton = [WCUIKitControl createButtonWithFrame:CGRectMake(buttonX, 0, buttonWidth, buttonWidth)
                                                                Target:self
                                                                Action:@selector(onRemoveAction)
                                                                 Title:@"移除"];
        removeButton.backgroundColor = WCButtonColor;
        removeButton.alpha = 0.5;
        [removeButton setTitleColor:WCWhite forState:UIControlStateNormal];
        WCViewBorder_Radius(removeButton, buttonWidth / 2);
        [self.contentView addSubview:(self.removeButton = removeButton)];
    }
    return _removeButton;
}

- (UIButton *)inviteButton
{
    if (!_inviteButton)
    {
        CGFloat buttonsHeight = self.height - 15;
        
        CGFloat buttonWidth = (buttonsHeight - 10) / 2;
        CGFloat buttonX = (self.width - buttonWidth) / 2;
        
        UIButton *inviteButton = [WCUIKitControl createButtonWithFrame:CGRectMake(buttonX, 10 + buttonWidth, buttonWidth, buttonWidth)
                                                                Target:self
                                                                Action:@selector(onInviteAction)
                                                                 Title:@"邀请"];
        inviteButton.backgroundColor = WCButtonColor;
        inviteButton.alpha = 0.5;
        [inviteButton setTitleColor:WCWhite forState:UIControlStateNormal];
        WCViewBorder_Radius(inviteButton, buttonWidth / 2);
        [self.contentView addSubview:(self.inviteButton = inviteButton)];
    }
    return _inviteButton;
}


- (void)onRemoveAction
{
    if (self.removeBlock)
    {
        self.removeBlock(_renderModel.identify);
    }
}

- (void)onInviteAction
{
    if (self.inviteBlock)
    {
        self.inviteBlock(_renderModel.identify);
    }
}

- (void)setImagesHidden:(BOOL)hidden
{
    self.onVioceImg.hidden = hidden;
    self.onCloseMicImg.hidden = hidden;
}

- (void)configWithModel:(M8CallRenderModel *)model radius:(CGFloat)radius
{
    _renderModel = model;
    
    if (model.isInUserAction)
    {
        [self configWithClick:model radius:radius];
    }
    else
    {
        [self configWithUnClick:model radius:radius];
    }
}

//用户正在进行点击操作
- (void)configWithClick:(M8CallRenderModel *)model radius:(CGFloat)radius
{
    self.identifyLabel.text = model.nick;
    
    self.effectView.hidden = NO;
    
    self.infoLabel.hidden = YES;
    
    [self setButtonsHidden:NO];
    [self setImagesHidden:YES];
}

//用户在房间内
- (void)configWithUnClick:(M8CallRenderModel *)model radius:(CGFloat)radius
{
    WCViewBorder_Radius(self.onVioceImg, radius);
    
    self.identifyLabel.text = model.nick;
    
    self.infoLabel.hidden = NO;
    
    self.effectView.hidden = NO;
    
    [self setImagesHidden:YES];
    [self setButtonsHidden:YES];
    
    
    switch (model.meetMemberStatus) {
        case MeetMemberStatus_none:
        {
            self.infoLabel.text = kMemberStatu_waiting;
        }
            break;
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
    [self.infoLabel     configLiveRenderText];
}

@end
