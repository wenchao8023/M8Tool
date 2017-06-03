//
//  RecordDetailView.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordDetailView.h"


@interface RecordDetailView ()

//@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *laucherLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *recieveLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *rejectLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *unresponseLabel;

@end



@implementation RecordDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    WCLog(@"4...->...awakeFromNib");
}

- (instancetype)initWithFrame:(CGRect)frame {
    WCLog(@"3...->...初始化");
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.frame = frame;
    }
    return self;
}

- (IBAction)launcherInfoAction:(id)sender {
    WCLog(@"点死木木");
}

@end
