//
//  M8FloatRenderView.m
//  M8FloatRenderView
//
//  Created by chao on 2017/6/16.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8FloatRenderView.h"

#import "M8CallRenderModel.h"

@interface M8FloatRenderView ()
{
    CGRect _myFrame;
}

@property (nonatomic, assign) CGPoint touchStartPosition;



/**
 config UI with model
 */
@property (weak, nonatomic) IBOutlet M8LiveLabel *identifyLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (weak, nonatomic) IBOutlet UIImageView *onCloseMicImg;

@property (weak, nonatomic) IBOutlet UIImageView *onVioceImg;

@end

@implementation M8FloatRenderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
        self.backgroundColor = WCClear;
        
    }
    return self;
}

- (void)configWithRenderModel:(M8CallRenderModel *)model {
    
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

- (void)drawRect:(CGRect)rect {
    self.frame = _myFrame;
    
    WCViewBorder_Radius(self.onVioceImg, self.onVioceImg.width / 2);
    [self.identifyLabel configLiveRenderText];
    [self.infoLabel configLiveRenderText];
}


typedef NS_ENUM(NSInteger ,M8FloatWindowDirection) {
    M8FloatWindowLEFT,
    M8FloatWindowRIGHT,
    M8FloatWindowTOP,
    M8FloatWindowBOTTOM
};

typedef NS_ENUM(NSInteger, M8ScreenChangeOrientation) {
    M8Change2Origin,
    M8Change2Upside,
    M8Change2Left,
    M8Change2Right
};

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.touchStartPosition = [touch locationInView:_rootView];
    self.touchStartPosition = [self ConvertDir:_touchStartPosition];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    curPoint = [self ConvertDir:curPoint];
    self.superview.center = curPoint;
    
    [self respondsToCenterDelegate];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    curPoint = [self ConvertDir:curPoint];
    // if the start touch point is too close to the end point, take it as the click event and notify the click delegate
    if (pow((_touchStartPosition.x - curPoint.x),2) + pow((_touchStartPosition.y - curPoint.y),2) < 1) {
        [self respondsToClickDelegate];    //这里表示点击了
        return;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat W = SCREEN_WIDTH;
    CGFloat H = SCREEN_HEIGHT;
    // (1,2->3,4 | 3,4->1,2)
    NSInteger judge = orientation + _initOrientation;
    if (orientation != _initOrientation && judge != 3 && judge != 7) {
        W = SCREEN_WIDTH;
        H = SCREEN_HEIGHT;
    }
    // distances to the four screen edges
    CGFloat left = curPoint.x;
    CGFloat right = W - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = H - curPoint.y;
    // find the direction to go
    M8FloatWindowDirection minDir = M8FloatWindowLEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = M8FloatWindowRIGHT;
    }
    if (top < minDistance) {
        minDistance = top;
        minDir = M8FloatWindowTOP;
    }
    if (bottom < minDistance) {
        minDir = M8FloatWindowBOTTOM;
    }
    
    switch (minDir) {
        case M8FloatWindowLEFT: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            }];
            break;
        }
        case M8FloatWindowRIGHT: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(W - self.superview.frame.size.width/2, self.superview.center.y);
            }];
            break;
        }
        case M8FloatWindowTOP: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
            }];
            break;
        }
        case M8FloatWindowBOTTOM: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, H - self.superview.frame.size.height/2);
            }];
            break;
        }
        default:
            break;
    }
    
    [self respondsToCenterDelegate];
}

- (void)floatViewRotate {
    M8ScreenChangeOrientation change2orien = [self screenChange];
    switch (change2orien) {
        case M8Change2Origin:
            self.transform = _originTransform;
            break;
        case M8Change2Left:
            self.transform = _originTransform;
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case M8Change2Right:
            self.transform = _originTransform;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case M8Change2Upside:
            self.transform = _originTransform;
            self.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        default:
            break;
    }

}

/**
 *  convert to the origin coordinate
 *
 *  UIInterfaceOrientationPortrait           = 1
 *  UIInterfaceOrientationPortraitUpsideDown = 2
 *  UIInterfaceOrientationLandscapeRight     = 3
 *  UIInterfaceOrientationLandscapeLeft      = 4
 */
- (CGPoint)ConvertDir:(CGPoint)p {
    M8ScreenChangeOrientation change2orien = [self screenChange];
    // covert
    switch (change2orien) {
        case M8Change2Left:
            return [self LandscapeLeft:p];
            break;
        case M8Change2Right:
            return [self LandscapeRight:p];
            break;
        case M8Change2Upside:
            return [self UpsideDown:p];
            break;
        default:
            return p;
            break;
    }
}

- (M8ScreenChangeOrientation)screenChange {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // 1. M8Change2Origin(1->1 | 2->2 | 3->3 | 4->4)
    if (_initOrientation == orientation) return M8Change2Origin;
    
    // 2. M8Change2Upside(1->2 | 2->1 | 4->3 | 3->4)
    NSInteger isUpside = orientation + _initOrientation;
    if (isUpside == 3 || isUpside == 7) return M8Change2Upside;
    
    // 3. M8Change2Left(1->4 | 4->2 | 2->3 | 3->1)
    // 4. M8Change2Right(1->3 | 3->2 | 2->4 | 4->1)
    M8ScreenChangeOrientation change2orien = 0;
    switch (_initOrientation) {
        case UIInterfaceOrientationPortrait:
            if (orientation == UIInterfaceOrientationLandscapeLeft)
                change2orien = M8Change2Left;
            else if(orientation == UIInterfaceOrientationLandscapeRight)
                change2orien = M8Change2Right;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            if (orientation == UIInterfaceOrientationLandscapeRight)
                change2orien = M8Change2Left;
            else if(orientation == UIInterfaceOrientationLandscapeLeft)
                change2orien = M8Change2Right;
            break;
        case UIInterfaceOrientationLandscapeRight:
            if (orientation == UIInterfaceOrientationPortrait)
                change2orien = M8Change2Left;
            else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
                change2orien = M8Change2Right;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if (orientation == UIInterfaceOrientationPortraitUpsideDown)
                change2orien = M8Change2Left;
            else if(orientation == UIInterfaceOrientationPortrait)
                change2orien = M8Change2Right;
            break;
            
        default:
            break;
    }
    return change2orien;
}

- (CGPoint)UpsideDown:(CGPoint)p {
    return CGPointMake(SCREEN_HEIGHT - p.x, SCREEN_WIDTH - p.y);
}

- (CGPoint)LandscapeLeft:(CGPoint)p {
    return CGPointMake(p.y, SCREEN_HEIGHT - p.x);
}

- (CGPoint)LandscapeRight:(CGPoint)p {
    return CGPointMake(SCREEN_WIDTH - p.y, p.x);
}


#pragma mark - respondToDelegate
- (void)respondsToCenterDelegate {
    if ([self.WCDelegate respondsToSelector:@selector(floatRenderViewCenter:)]) {
        [self.WCDelegate floatRenderViewCenter:self.superview.center];
    }
}

- (void)respondsToClickDelegate {
    if ([self.WCDelegate respondsToSelector:@selector(floatRenderViewDidClicked)]) {
        [self.WCDelegate floatRenderViewDidClicked];
    }
}


@end
