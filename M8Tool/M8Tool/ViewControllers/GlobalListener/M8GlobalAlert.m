//
//  M8GlobalAlert.m
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8GlobalAlert.h"

@interface M8GlobalAlert ()
{
    CGRect _curFrame;
    NSString *_alertInfo;
    GlobalAlertType _alertType;
}

@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;



@end

@implementation M8GlobalAlert

- (instancetype)initWithFrame:(CGRect)frame alertInfo:(NSString *)alertInfo alertType:(GlobalAlertType)alertType
{
    if (self = [super initWithFrame:frame])
    {
        self       = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _curFrame  = frame;
        _alertInfo = alertInfo;
        _alertType = alertType;
        
        [self configUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
    /**
     *  设置frame
     */
    _curFrame.origin = CGPointMake((SCREEN_WIDTH - _curFrame.size.width) / 2, (SCREEN_HEIGHT - _curFrame.size.height) / 2);
    self.frame       = _curFrame;
    
    
    /**
     *  设置视图圆角、阴影
     */
    WCViewBorder_Radius(self, 4);
    
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    
    
    /**
     *  设置按钮边框
     */
    CGFloat borderWidth = 0.5;
    [self.leftButton setBorder_top_color:WCButtonColor width:borderWidth];
    [self.rightButton setBorder_top_color:WCButtonColor width:borderWidth];
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(_curFrame.size.width / 2 - borderWidth, 0, borderWidth, 40);
    layer.backgroundColor = WCButtonColor.CGColor;
    [self.leftButton.layer addSublayer:layer];
}

/**
 *  重新设置alertView的大小
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _curFrame.size.height = CGRectGetMaxY(self.leftButton.frame);
    self.frame            = _curFrame;
}



- (void)configUI
{
    switch (_alertType)
    {
        case GlobalAlertType_forceOffline:
        {
            [self.leftButton setAttributedTitle:[CommonUtil customAttString:@"退出" textColor:WCBlack] forState:UIControlStateNormal];
            [self.rightButton setAttributedTitle:[CommonUtil customAttString:@"重新登录" textColor:WCBlack] forState:UIControlStateNormal];
            
            [self.alertTitleLabel setAttributedText:[CommonUtil customAttString:@"下线通知" fontSize:kAppLargeFontSize + 1]];
            
            NSAttributedString *attStr = [self alertInfoAttStr];
            CGSize infoLabelSize       = [self sizeWithAttString:attStr];
            
            [self.alertInfoLabel setAttributedText:attStr];
            self.alertInfoLabel.size = infoLabelSize;
        }
            break;
            
        default:
            break;
    }
}

- (NSAttributedString *)alertInfoAttStr
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //设置字体属性
    [attDict setValue:[UIFont fontWithName:kFontNameSTHeiti_Light size:kAppMiddleFontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    [attDict setValue:WCBlack forKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    NSMutableParagraphStyle *paragraphStyle;
    paragraphStyle                        = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing            = 0.0;//增加行高
    paragraphStyle.headIndent             = 0;//头部缩进，相当于左padding
    paragraphStyle.tailIndent             = 0;//相当于右padding
    paragraphStyle.lineHeightMultiple     = 1.2;//行间距是多少倍
    paragraphStyle.alignment              = NSTextAlignmentLeft;//对齐方式
    paragraphStyle.firstLineHeadIndent    = 0;//首行头缩进
    paragraphStyle.paragraphSpacing       = 0;//段落后面的间距
    paragraphStyle.paragraphSpacingBefore = 0;//段落之前的间距
    
    [attDict setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return [[NSAttributedString alloc] initWithString:_alertInfo attributes:attDict];
}

- (CGSize)sizeWithAttString:(NSAttributedString *)attStr
{
    return [attStr boundingRectWithSize:CGSizeMake((_curFrame.size.width - 40), MAXFLOAT)
                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                context:nil].size;
}


- (IBAction)onLeftButtonAction:(id)sender
{
    if ([self.WCDelegate respondsToSelector:@selector(onGlobalAlertLeftButtonAction)])
    {
        [self.WCDelegate onGlobalAlertLeftButtonAction];
    }
}

- (IBAction)onRightButtonAction:(id)sender
{
    if ([self.WCDelegate respondsToSelector:@selector(onGlobalAlertRightButtonAction)])
    {
        [self.WCDelegate onGlobalAlertRightButtonAction];
    }
}



@end
