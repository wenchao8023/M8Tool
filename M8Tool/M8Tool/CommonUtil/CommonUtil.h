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
 *  获取最近15天的日期
 *
 *  @return 日期数组
 */
+ (NSArray *_Nullable)getCalendarData;


/**
 *  打电话
 *
 *  @param phoneStr 电话号码字符串
 */
+ (void)makePhone:(NSString *_Nullable)phoneStr;


/**
 *  提示是否在会议中
 *
 *  @return return 会议状态
 */
+(BOOL)alertTipInMeeting;


/**
 *  将时间戳转成日期格式
 *
 *  @param time 时间戳
 *
 *  @return 日期字符串
 */
+(NSString *_Nullable)getDateStrWithTime:(NSTimeInterval)time;


/**
 *  获取会议记录时间戳格式
 *
 *  @param time 时间戳
 *
 *  @return 格式字符串
 */
+ (NSString *_Nullable)getRecordDateStr:(NSTimeInterval)time;


/**
 *  带阴影的富文本 默认：白色文字、黑色模糊
 *
 *  @param str 文本
 *
 *  @return 带阴影的富文本
 */
+(NSMutableAttributedString *_Nullable)getShadowStr:(NSString *_Nullable)str ;


/**
 *  带阴影的富文本
 *
 *  @param str         文本
 *  @param font        文本大小
 *
 *  @return 带阴影的富文本
 */
+(NSMutableAttributedString *_Nullable)getShadowStr:(NSString *_Nullable)str
                                               font:(CGFloat)font ;

/**
 *  带阴影的富文本
 *
 *  @param str         文本
 *  @param font        文本大小
 *  @param textColor   文本颜色
 *  @param shadowColor 阴影颜色
 *
 *  @return 带阴影的富文本
 */
+(NSMutableAttributedString *_Nullable)getShadowStr:(NSString *_Nullable)str
                                               font:(CGFloat)font
                                          textColor:(UIColor *_Nullable)textColor
                                        shadowColor:(UIColor *_Nullable)shadowColor ;


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
 @param textColor   文字颜色
 @return            富文本
 */
+(NSMutableAttributedString *_Nullable)customAttString:(NSString *_Nullable)string
                                             textColor:(UIColor *_Nullable)textColor;

/**
 富文本
 
 @param string      原始文本
 @param fontSize    文字大小
 @param textColor   文字颜色
 @return            富文本
 */
+(NSMutableAttributedString *_Nullable)customAttString:(NSString *_Nullable)string
                                              fontSize:(CGFloat)fontSize
                                             textColor:(UIColor *_Nullable)textColor;


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
@end
