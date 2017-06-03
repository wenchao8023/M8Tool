//
//  MeetingButtonsCell.m
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MeetingButtonsCell.h"

/**
 描边的 Label
 */
@interface DrawTextLabel : UILabel

@end

@implementation DrawTextLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 0.8);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = WCBlack;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end




@interface MeetingButtonsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet DrawTextLabel *titleLabel;

@end

@implementation MeetingButtonsCell


- (void)configWithTitle:(NSString *)title imageStr:(NSString *)imageStr {
    // 设置富文本属性
    [self.titleLabel setAttributedText:[CommonUtil customAttString:title
                                                          fontSize:kAppMiddleFontSize
                                                         textColor:WCWhite
                                                         charSpace:kAppKern_0]
     ];
    // 描边
    [self.titleLabel drawTextInRect:self.titleLabel.bounds];
    
    self.iconImage.image = [[UIImage imageNamed:imageStr] imageDrawClearRect];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end






