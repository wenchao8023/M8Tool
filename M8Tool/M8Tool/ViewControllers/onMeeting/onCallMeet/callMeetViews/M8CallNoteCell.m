//
//  M8CallNoteCell.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallNoteCell.h"
#import "M8CallNoteModel.h"


@interface M8CallNoteCell ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@end





@implementation M8CallNoteCell


- (void)configWithModel:(M8CallNoteModel *)model width:(CGFloat)selfWidth
{
    self.width = selfWidth;
    
    WCViewBorder_Radius(self.effectView, 4);
    
    NSMutableAttributedString *textAttStr = [[NSMutableAttributedString alloc] init];
    CGSize textSize;
    
    if (model.name)
    {
        if (model.tipInfo)
        {
            NSAttributedString *nameAttStr = [self nameAttString:model.name textColor:(model.record ? WCYellow : WCWhite)];
            [textAttStr appendAttributedString:nameAttStr];
            
            NSAttributedString *tipAttStr = [self msgAttString:model.tipInfo textColor:WCWhite];
            [textAttStr appendAttributedString:tipAttStr];
        }
        else if (model.msgInfo)
        {
            NSAttributedString *nameAttStr = [self nameAttString:[NSString stringWithFormat:@"%@ : ", model.name] textColor:(model.record ? WCYellow : WCWhite)];
            [textAttStr appendAttributedString:nameAttStr];
     
            NSAttributedString *tipAttStr = [self msgAttString:model.msgInfo textColor:WCWhite];
            [textAttStr appendAttributedString:tipAttStr];
        }
    }
    else
    {
        if (model.tipInfo)
        {
            NSAttributedString *tipAttStr = [self msgAttString:model.tipInfo textColor:WCLightGray];
            [textAttStr appendAttributedString:tipAttStr];
        }
    }
    
    textSize = [self sizeWithDefaultHeightAndAttString:textAttStr];
    if (textSize.width > self.width - 24)
    {
        textSize = [self sizeWithAttString:textAttStr];
    }
    
    self.infoLable.size  = textSize;
    self.effectView.size = CGSizeMake(textSize.width + 8, textSize.height + 8);
    
    [self.infoLable setAttributedText:textAttStr];
}

- (NSAttributedString *)nameAttString:(NSString *)name textColor:(UIColor *)textColor
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //设置字体属性
    [attDict setValue:[UIFont fontWithName:@"DroidSansFallback" size:kAppMiddleFontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
    //设置字符间距
    [attDict setValue:@(2) forKey:NSKernAttributeName];
    
    return [[NSAttributedString alloc] initWithString:name attributes:attDict];
}

- (NSAttributedString *)msgAttString:(NSString *)msg textColor:(UIColor *)textColor
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //设置字体属性
    [attDict setValue:[UIFont fontWithName:@"DroidSansFallback" size:kAppSmallFontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
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
    
    return [[NSAttributedString alloc] initWithString:msg attributes:attDict];
}


- (CGSize)sizeWithAttString:(NSAttributedString *)attStr
{
    return [attStr boundingRectWithSize:CGSizeMake(self.width - 24, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

- (CGSize)sizeWithDefaultHeightAndAttString:(NSAttributedString *)attStr
{
    return [attStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}















- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
