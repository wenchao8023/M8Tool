//
//  CommonUtil.m
//  M8Tool
//
//  Created by chao on 2017/4/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil


+(void)saveUserID:(NSString *)userid {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:userid forKey:@"loginUserid"];
    
    [def synchronize];
}

+(NSString *)getUserID {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserid"];
}

+(NSString *)getIconLabelStr:(NSString *)str {
    
    if (str.length <= 2) {
        return str;
        
    } else if (str.length <=3) {
        return [str substringFromIndex:1];
        
    } else if (str.length <= 4) {
        return [str substringFromIndex:2];
        
    } else {
        return [str substringToIndex:2];
    }
}

+(NSString *)getDateStrWithTime:(NSTimeInterval)time
{
    NSString *timeStr;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    timeStr = [formatter stringFromDate:startDate];
    return timeStr;
}


+ (BOOL)AVAuthorizationStatusAudio {
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioStatus == AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied)
    {
        [AlertHelp alertWith:nil message:@"您没有麦克风使用权限,请到 设置->隐私->麦克风 中开启权限" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return NO;
    }
    return YES;
}

+ (BOOL)AVAuthorizationStatusVideo {
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoStatus == AVAuthorizationStatusRestricted || videoStatus == AVAuthorizationStatusDenied)
    {
        [AlertHelp alertWith:nil message:@"您没有相机使用权限,请到 设置->隐私->相机 中开启权限" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return NO;
    }
    return YES;
}

// 文字模糊背景
// 默认：白色文字、黑色模糊
// 文字大小 16
+(NSMutableAttributedString *)getShadowStr:(NSString *)str {
    
    return [self getShadowStr:str
                         font:[UIFont systemFontSize]
            ];
//    NSRange range = NSMakeRange(0, str.length);
//    
//    NSShadow *shadow = [[NSShadow alloc] init];
//    
//    shadow.shadowBlurRadius = 5;    //模糊度
//    
//    shadow.shadowColor = [UIColor blackColor];
//    
//    shadow.shadowOffset = CGSizeMake(1, 3);
//    
//    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
//                           NSForegroundColorAttributeName : [UIColor whiteColor],
//                           NSShadowAttributeName : shadow};
//    
//    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
//    
//    [attText setAttributes:dict range:range];
//    
//    return attText;
}

+(NSMutableAttributedString *)getShadowStr:(NSString *)str font:(CGFloat)font {

    return [self getShadowStr:str
                         font:font
                    textColor:[UIColor whiteColor]
                  shadowColor:[UIColor blackColor]];
}

+(NSMutableAttributedString *)getShadowStr:(NSString *)str
                                      font:(CGFloat)font
                                 textColor:(UIColor *)textColor
                               shadowColor:(UIColor *)shadowColor {
    
    NSRange range = NSMakeRange(0, str.length);
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowBlurRadius = 5;    //模糊度
    
    shadow.shadowColor = shadowColor;
    
    shadow.shadowOffset = CGSizeMake(1, 3);
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:font],
                           NSForegroundColorAttributeName : textColor,
                           NSShadowAttributeName : shadow};
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attText setAttributes:dict range:range];
    
    return attText;
}
#pragma mark - 文本属性


/**
 自定义大小，字体为 DroidSansFallback 的文本
 
 @param string 修饰文本
 @return 返回自定义 大小 字体文本属性
 */
+(NSMutableAttributedString *)customAttString:(NSString *)string
                                     fontSize:(CGFloat)fontSize
{
    return [self customAttString:string
                        fontSize:fontSize
                       textColor:nil];
}

+(NSMutableAttributedString *)customAttString:(NSString *)string
                                     fontSize:(CGFloat)fontSize
                                    textColor:(UIColor *)textColor
{
    return [self customAttString:string
                        fontSize:fontSize
                       textColor:textColor
                       charSpace:0];
}


+(NSMutableAttributedString *)customAttString:(NSString *)string
                                     fontSize:(CGFloat)fontSize
                                    textColor:(UIColor *)textColor
                                    charSpace:(int)charSpace
{
    return [self customAttString:string
                        fontSize:fontSize
                       textColor:textColor
                       charSpace:charSpace
                        fontName:nil];
}
+(NSMutableAttributedString *)customAttString:(NSString *)string
                                     fontSize:(CGFloat)fontSize
                                    textColor:(UIColor *)textColor
                                    charSpace:(int)charSpace
                                     fontName:(NSString *)fontName
{
    if (string)
        return [[NSMutableAttributedString alloc] initWithString:string
                                                      attributes:[self customAttsWithFontSize:fontSize
                                                                                    textColor:textColor
                                                                                    charSpace:charSpace
                                                                                     fontName:fontName]];
    return nil;
}

+(NSMutableDictionary *)customAttsWithBodyFontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //设置字体-粗体、大小
    [attDict setValue:[UIFont boldSystemFontOfSize:fontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    if (textColor)
        [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
    return attDict;
}
+(NSMutableDictionary *)customAttsWithFontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor
                                     charSpace:(int)charSpace {
    return [self customAttsWithFontSize:fontSize
                              textColor:textColor
                              charSpace:charSpace
                               fontName:kFontNameHeiti_SC];
}
+(NSMutableDictionary *)customAttsWithFontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor
                                     charSpace:(int)charSpace
                                      fontName:(NSString *)fontName
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //设置字体、大小
    if (fontName && fontSize)
        [attDict setValue:[UIFont fontWithName:fontName size:fontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    if (textColor)
        [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
    //设置字符间距
    if (charSpace)
        [attDict setValue:@(charSpace) forKey:NSKernAttributeName];
    return attDict;
}


+(NSMutableAttributedString *)nonusecustomAttString:(NSString *)string {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //设置字体 (默认大小)
    [attDict setValue:[UIFont fontWithName:@"DroidSansFallback" size:0] forKey:NSFontAttributeName];
    //设置字体颜色
    [attDict setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    //设置字体背景颜色
    [attDict setValue:[UIColor clearColor] forKey:NSBackgroundColorAttributeName];
    //设置字符间距
    [attDict setValue:@(4) forKey:NSKernAttributeName];
    
    //段落属性
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraph.lineSpacing = 10;
    //段落间距
    paragraph.paragraphSpacing = 20;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 30;
    //调整全部文字的缩进像素
    paragraph.headIndent = 10;
    
    //设置段落属性
    [attDict setValue:paragraph forKey:NSParagraphStyleAttributeName];
    
    [attString setAttributes:attDict range:NSMakeRange(0, string.length)];
    return attString;
}

@end
