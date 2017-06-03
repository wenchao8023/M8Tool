//
//  RecorDetailView.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecorDetailView.h"

@interface RecorDetailView ()

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *laucherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *recieveLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectLabel;
@property (weak, nonatomic) IBOutlet UILabel *unresponseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statuImage;


@end


@implementation RecorDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        self.frame = frame;
        
        // 需要在最下方添加未响应成员列表
    }
    return self;
}


- (IBAction)luacherDetailAction:(id)sender {
     WCLog(@"我在点木木");
}

@end
