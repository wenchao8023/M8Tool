//
//  MeetingButtonsCell.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingButtonsCell.h"


@interface MeetingButtonsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet THLabel *titleLabel;

@end

@implementation MeetingButtonsCell


- (void)configWithTitle:(NSString *)title imageStr:(NSString *)imageStr {
    // 设置富文本属性
    [self.titleLabel setAttributedText:[CommonUtil customAttString:title
                                                          fontSize:kAppMiddleFontSize
                                                         textColor:WCWhite
                                                         charSpace:kAppKern_0]
     ];
    
    self.iconImage.image = [[UIImage imageNamed:imageStr] imageDrawClearRect];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.strokeColor = kLiveStrokeColor;
    self.titleLabel.strokeSize  = kLiveStrokeSize;
}
@end






