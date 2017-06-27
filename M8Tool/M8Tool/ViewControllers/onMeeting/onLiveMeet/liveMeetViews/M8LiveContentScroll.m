//
//  M8LiveContentScroll.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveContentScroll.h"

#import "M8LiveHeaderView.h"
#import "M8LiveDeviceView.h"


@interface M8LiveContentScroll ()<UIScrollViewDelegate>

@property (nonatomic, strong) M8LiveHeaderView *headerView;
@property (nonatomic, strong) M8LiveDeviceView *deviceView;

@end

@implementation M8LiveContentScroll

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self configParams];
        
        [self loadSubviews];
    }
    return self;
}

- (void)configParams {

    self.delegate = self;
    self.pagingEnabled = YES;
    self.directionalLockEnabled = YES;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(self.width * 2, self.height);
    self.contentOffset = CGPointMake(self.width, 0);

}

- (void)loadSubviews {
    
    // 设置第二页的蒙版
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(self.width, 0, self.width, self.height);
    [self addSubview:effectView];
    
    [self addSubview:self.headerView];
    [self addSubview:self.deviceView];
}

- (M8LiveHeaderView *)headerView {
    if (!_headerView) {
        M8LiveHeaderView *headerView = [[M8LiveHeaderView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, kDefaultNaviHeight)];
        _headerView = headerView;
    }
    return _headerView;
}

- (M8LiveDeviceView *)deviceView {
    if (!_deviceView) {
        M8LiveDeviceView *deviceView = [[M8LiveDeviceView alloc] initWithFrame:CGRectMake(self.width, self.height - kBottomHeight, self.width, kBottomHeight) deviceType:M8LiveDeviceTypeHost];
        _deviceView = deviceView;
    }
    return _deviceView;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    WCLog(@"gestureRecognizerShouldBegin");
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    WCLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


@end
