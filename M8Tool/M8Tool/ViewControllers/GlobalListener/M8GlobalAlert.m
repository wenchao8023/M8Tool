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
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
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
    _curFrame.origin = CGPointMake((SCREEN_WIDTH - _curFrame.size.width) / 2, (SCREEN_HEIGHT - _curFrame.size.height) / 2);
    self.frame = _curFrame;
    
    WCViewBorder_Radius(self, 4);
    
    [self.leftButton setBorder_top_color:WCButtonColor width:0.6];
    [self.rightButton setBorder_top_color:WCButtonColor width:0.6];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(_curFrame.size.width / 2 - 0.6, 0, 0.6, 40);
    layer.backgroundColor = WCButtonColor.CGColor;
    [self.leftButton.layer addSublayer:layer];
    
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
}

- (void)configUI
{
    switch (_alertType)
    {
        case GlobalAlertType_forceOffline:
        {
            [self.leftButton setAttributedTitle:[CommonUtil customAttString:@"退出"] forState:UIControlStateNormal];
            [self.rightButton setAttributedTitle:[CommonUtil customAttString:@"重新登录"] forState:UIControlStateNormal];
            
            [self.alertTitleLabel setAttributedText:[CommonUtil customAttString:@"下线通知" fontSize:kAppLargeFontSize + 1]];
            [self.alertInfoLabel setAttributedText:[self alertInfoAttStr]];
            
            CGSize infoLabelSize = [self sizeWithAttString:[self alertInfoAttStr]];
            _curFrame.size.height = infoLabelSize.height + 128;
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
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSMutableParagraphStyle *paragraphStyle;
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 0.0;//增加行高
    paragraphStyle.headIndent = 0;//头部缩进，相当于左padding
    paragraphStyle.tailIndent = 0;//相当于右padding
    paragraphStyle.lineHeightMultiple = 1.2;//行间距是多少倍
    paragraphStyle.alignment = NSTextAlignmentLeft;//对齐方式
    paragraphStyle.firstLineHeadIndent = 0;//首行头缩进
    paragraphStyle.paragraphSpacing = 0;//段落后面的间距
    paragraphStyle.paragraphSpacingBefore = 0;//段落之前的间距
    
    [attDict setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    return [[NSAttributedString alloc] initWithString:_alertInfo attributes:attDict];
}

- (CGSize)sizeWithAttString:(NSAttributedString *)attStr
{
    return [attStr boundingRectWithSize:CGSizeMake(_curFrame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
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
