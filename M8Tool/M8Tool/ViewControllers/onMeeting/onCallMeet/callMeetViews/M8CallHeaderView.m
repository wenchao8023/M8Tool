//
//  M8CallHeaderView.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallHeaderView.h"


@interface M8CallHeaderView ()
{
    CGRect _myFrame;
    int _beginTime; // 单位 s
}

/**
 会议主题
 */
@property (weak, nonatomic) IBOutlet M8LiveLabel *topicLabel;

/**
 会议时间
 */
@property (weak, nonatomic) IBOutlet M8LiveLabel *durationLabel;

/**
 会议发起人
 */
@property (weak, nonatomic) IBOutlet M8LiveLabel *luancherLabel;


@end

@implementation M8CallHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
        _beginTime = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
    
    [self.topicLabel    configLiveText];
    [self.durationLabel configLiveText];
    [self.luancherLabel configLiveText];
}

- (void)configHeaderView:(TCShowLiveListItem *)item
{
    self.topicLabel.text = item.info.title;
    self.luancherLabel.text = item.info.host;
    [self beginCountTime];
}

- (void)beginCountTime {
    
    _beginTime = 1;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [timer fire];
    
}

- (void)countTime {
    
    self.durationLabel.text = [self getTimeStr:++_beginTime];
}

- (NSString *)getTimeStr:(int)time {
    NSString *str;
    if (time < 60) {
        str = [NSString stringWithFormat:@"%d", time];
    }
    else if (time < 60*60) {
        str = [NSString stringWithFormat:@"%02d:%02d", time / 60, time % 60];
    }
    else {
        str = [NSString stringWithFormat:@"%d:%02d", time / 60 / 60, (time % 3600) / 60];
    }
    return str;
}


#pragma mark - MeetHeaderDelegate:
- (void)headerActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(MeetHeaderActionInfo:)]) {
        [self.WCDelegate MeetHeaderActionInfo:actionInfo];
    }
}

@end
