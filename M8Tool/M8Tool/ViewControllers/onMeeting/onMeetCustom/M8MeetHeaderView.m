//
//  M8MeetHeaderView.m
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetHeaderView.h"


@interface M8MeetHeaderView ()
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UIButton *enlargeButton;

@property (weak, nonatomic) IBOutlet M8LiveLabel *topicLabel;
@property (weak, nonatomic) IBOutlet M8LiveLabel *durationLabel;


@end

@implementation M8MeetHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
    
    [self.topicLabel    configLiveText];
    [self.durationLabel configLiveText];
}

- (IBAction)enlargeAction:(id)sender {
    
    [self headerActionInfoValue:@"缩小视图" key:kHeaderAction];
    
}



#pragma mark - MeetHeaderDelegate:
- (void)headerActionInfoValue:(id)value key:(NSString *)key {
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(MeetHeaderActionInfo:)]) {
        [self.WCDelegate MeetHeaderActionInfo:actionInfo];
    }
}

@end
