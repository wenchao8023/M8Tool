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
    
#warning CGContextSetLineWidth: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
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
//    [self.titleLabel drawTextInRect:self.titleLabel.bounds];
    
    self.iconImage.image = [[UIImage imageNamed:imageStr] imageDrawClearRect];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleLabel drawTextInRect:self.titleLabel.bounds];
}

    
    

    /*
     -(void)createCircle
     {
     CGPoint layerCenter = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetWidth(self.view.frame)/2);
     CAShapeLayer *layer = [CAShapeLayer layer];
     layer.frame = self.view.bounds;
     layer.lineWidth = 6.0;
     layer.strokeColor = [UIColor redColor].CGColor;
     layer.fillColor = [UIColor whiteColor].CGColor;
     
     self.path = [UIBezierPath bezierPath];
     [self.path addArcWithCenter:layerCenter radius:50 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
     
     [self.path stroke];
     [self.path fill];
     layer.path = self.path.CGPath;
     [self.view.layer addSublayer:layer];
     }
     */
    /*
     -(void)createCircle
     {
     CGPoint layerCenter = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetWidth(self.view.frame)/2);
     CAShapeLayer *layer = [CAShapeLayer layer];
     layer.frame = self.view.bounds;
     layer.lineWidth = 6.0;
     layer.strokeColor = [UIColor redColor].CGColor;
     layer.fillColor = [UIColor whiteColor].CGColor;
     
     self.path = [UIBezierPath bezierPath];
     [self.path addArcWithCenter:layerCenter radius:50 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
     
     layer.path = self.path.CGPath;
     
     UIGraphicsBeginImageContext(self.view.bounds.size);
     [self.path stroke];
     [self.path fill];
     UIGraphicsEndImageContext();
     
     [self.view.layer addSublayer:layer];
     }
     */
    
    
    
    
    /*
     -(void)createCircle
     {
     CGPoint layerCenter = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetWidth(self.view.frame)/2);
     CAShapeLayer *layer = [CAShapeLayer layer];
     layer.frame = self.view.bounds;
     layer.lineWidth = 6.0;
     layer.strokeColor = [UIColor redColor].CGColor;
     layer.fillColor = [UIColor whiteColor].CGColor;
     self.path = [UIBezierPath bezierPath];
     [self.path addArcWithCenter:layerCenter radius:50 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
     //    [self.path stroke];
     //    [self.path fill];
     layer.path = self.path.CGPath;
     [self.view.layer addSublayer:layer];
     [self.view setNeedsDisplay];
     }
     - (void) drawRect:(CGRect)rect {
     [self.path stroke];
     [self.path fill];
     }
     */
    
    
@end






