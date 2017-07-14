//
//  M8LiveInfoView.m
//  M8Tool
//
//  Created by chao on 2017/6/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveInfoView.h"


@interface M8LiveInfoView ()


@end

@implementation M8LiveInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = WCClear;
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

        UIImageView *effectImg = [WCUIKitControl createImageViewWithFrame:self.bounds ImageName:@"QQAVEffect7_1"];
        effectImg.alpha = 0.1;
        [self addSubview:effectImg];
//        UIVisualEffectView *headerEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        headerEffectView.frame = CGRectMake(0, 0, self.width, kDefaultNaviHeight);
//        headerEffectView.alpha = 0.1;
//        [self addSubview:headerEffectView];
//        
//        UIVisualEffectView *bottomEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        bottomEffectView.frame = CGRectMake(0, self.height - kBottomHeight, self.width, kBottomHeight);
//        bottomEffectView.alpha = 0.1;
//        [self addSubview:bottomEffectView];
//        
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = CGRectMake(0, 0, self.width, self.height);
//        effectView.alpha = 0.1;
//        [self addSubview:effectView];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = CGRectMake(0, 0, self.width, self.height);
//        effectView.alpha = 0.6;
//        [self addSubview:effectView];
    }
    return self;
}

#pragma mark - UI相关
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BOOL ret = [[NSUserDefaults standardUserDefaults] boolForKey:kPushMenuStatus];
    if (ret)
    {
        [WCNotificationCenter postNotificationName:kHiddenMenuView_Notifycation object:nil];
        return ;
    }
    
    [self endEditing:YES];
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kHiddenMenuView_Notifycation object:nil];
}

@end
