//
//  CommonUtil.h
//  M8Tool
//
//  Created by chao on 2017/4/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CommonUtil : NSObject


/**
 获取最近15天的日期

 @return 日期数组
 */
+ (NSArray *_Nullable)getCalendarData;

+ (void)makePhone:(NSString *_Nullable)phoneStr;

+(NSString *_Nullable)getIconLabelStr:(NSString *_Nullable)str ;

+(BOOL)alertTipInMeeting;


/**
 将时间戳转成日期格式

 @param time 时间戳
 @return 日期字符串
 */
+(NSString *_Nullable)getDateStrWithTime:(NSTimeInterval)time;





/**
 获取会议记录时间戳格式

 @param time 时间戳
 @return 格式字符串
 */
+ (NSString *_Nullable)getRecordDateStr:(NSTimeInterval)time;

// 文字模糊背景
// 默认：白色文字、黑色模糊
// 文字默认 16
+(NSMutableAttributedString *_Nullable)getShadowStr:(NSString *_Nullable)str ;

+(NSMutableAttributedString *_Nullable)getShadowStr:(NSString *_Nullable)str
                                      font:(CGFloat)font ;

+(NSMutableAttributedString *_Nullable)getShadowStr:(NSString *_Nullable)str
                                      font:(CGFloat)font
                                 textColor:(UIColor *_Nullable)textColor
                               shadowColor:(UIColor *_Nullable)shadowColor ;

/**
 富文本
 
 @param string      原始文本
 @return            富文本
 */
+(NSMutableAttributedString *_Nullable)customAttString:(NSString *_Nullable)string;
/**
 富文本
 
 @param string      原始文本
 @param fontSize    文字大小
 @return            富文本
 */
+(NSMutableAttributedString *_Nullable)customAttString:(NSString *_Nullable)string
                                     fontSize:(CGFloat)fontSize;

/**
 富文本
 
 @param string      原始文本
 @param fontSize    文字大小
 @param textColor   文字颜色
 @param charSpace   文字间距
 @return            富文本
 */
+(NSMutableAttributedString *_Nullable)customAttString:(NSString *_Nullable)string
                                     fontSize:(CGFloat)fontSize
                                    textColor:(UIColor *_Nullable)textColor
                                    charSpace:(int)charSpace;


/**
 富文本

 @param string      原始文本
 @param fontSize    文字大小
 @param textColor   文字颜色
 @param charSpace   文字间距
 @param fontName    文字字体
 @return            富文本
 */
//+(NSMutableAttributedString *_Nullable)customAttString:(NSString *_Nullable)string
//                                     fontSize:(CGFloat)fontSize
//                                    textColor:(UIColor *_Nullable)textColor
//                                    charSpace:(int)charSpace
//                                     fontName:(NSString *_Nullable)fontName;


/**
 粗文本属性

 @param fontSize    粗字体大小
 @param textColor   粗字体颜色
 @return            粗文本属性
 */
+(NSMutableDictionary *_Nullable)customAttsWithBodyFontSize:(CGFloat)fontSize
                                         textColor:(UIColor *_Nullable)textColor;

/**
 文本属性

 @param fontSize    文字大小
 @param textColor   文字颜色
 @param charSpace   文字间距
 @return            文本属性
 */
+(NSMutableDictionary *_Nullable)customAttsWithFontSize:(CGFloat)fontSize
                                     textColor:(UIColor *_Nullable)textColor
                                     charSpace:(int)charSpace;

/**
 文本属性
 
 @param fontSize    文字大小
 @param textColor   文字颜色
 @param charSpace   文字间距
 @param fontName    文字字体
 @return            文本属性
 */
//+(NSMutableDictionary *_Nullable)customAttsWithFontSize:(CGFloat)fontSize
//                                     textColor:(UIColor *_Nullable)textColor
//                                     charSpace:(int)charSpace
//                                      fontName:(NSString *_Nullable)fontName;
@end
