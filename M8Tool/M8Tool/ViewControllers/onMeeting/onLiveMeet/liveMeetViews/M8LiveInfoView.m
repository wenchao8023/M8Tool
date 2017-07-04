//
//  M8LiveInfoView.m
//  M8Tool
//
//  Created by chao on 2017/6/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveInfoView.h"


@interface M8LiveInfoView ()

@property (nonatomic, strong) M8LiveHeaderView *headerView;
@property (nonatomic, strong) M8LiveNoteView   *noteView;
@property (nonatomic, strong) M8LiveDeviceView *deviceView;

@end

@implementation M8LiveInfoView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WCClear;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, self.width, self.height);
        effectView.alpha = 0.6;
        [self addSubview:effectView];
        
        [self addSubview:self.headerView];
        [self addSubview:self.noteView];
        [self addSubview:self.deviceView];
    }
    return self;
}

- (M8LiveHeaderView *)headerView {
    if (!_headerView) {
        M8LiveHeaderView *headerView = [[M8LiveHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, kDefaultNaviHeight)];
        _headerView = headerView;
    }
    return _headerView;
}

- (M8LiveNoteView *)noteView {
    if (!_noteView) {
        M8LiveNoteView *noteView = [[M8LiveNoteView alloc] initWithFrame:CGRectMake(0, self.height - kBottomHeight - 200, self.width, 200)];
        _noteView = noteView;
    }
    return _noteView;
}
- (M8LiveDeviceView *)deviceView {
    if (!_deviceView) {
        M8LiveDeviceView *deviceView = [[M8LiveDeviceView alloc] initWithFrame:CGRectMake(0, self.height - kBottomHeight, self.width, kBottomHeight)];
        deviceView.WCDelegate = self;
        _deviceView = deviceView;
    }
    return _deviceView;
}



#pragma mark - 水平滑动隐藏
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    //    水平手势判断
    if (self.frame.origin.x > SCREEN_WIDTH * 0.2) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.frame = frame;
            
        }];
        
    }else{
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = 0;
            self.frame = frame;
        }];
    }
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.frame.origin.x > SCREEN_WIDTH * 0.2) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.frame = frame;
        }];
        
    }else{
        [UIView animateWithDuration:0.06 animations:^{
            CGRect frame = self.frame;
            frame.origin.x = 0;
            self.frame = frame;
        }];
    }
    
}


#pragma mark - public action
- (void)addTextToView:(id)newText {
    NSString *text = self.noteView.textView.text;
    
    NSString *dicStr = [NSString stringWithFormat:@"%@", newText];
    
    dicStr = [dicStr stringByAppendingString:@"\n"];
    dicStr = [dicStr stringByAppendingString:text];
    
    self.noteView.textView.text = dicStr;
}





@end
