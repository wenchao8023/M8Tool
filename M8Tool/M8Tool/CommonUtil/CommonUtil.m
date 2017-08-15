//
//  CommonUtil.m
//  M8Tool
//
//  Created by chao on 2017/4/7.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (NSArray *)getCalendarData
{
    NSMutableArray *fifthDaysArr = [NSMutableArray arrayWithCapacity:0];
    
    NSDate *todayDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateComponents *comps = [DAYUtils dateComponentsFromDate:todayDate];

    NSUInteger currentYear  = comps.year;
    NSUInteger currentMonth = comps.month;
    NSUInteger currentDay   = comps.day;
    NSUInteger currentTotalDays = [DAYUtils daysInMonth:currentMonth ofYear:currentYear];
    NSUInteger currentWeekday = [DAYUtils weekdataInMonth:currentMonth ofDay:currentDay ofYear:currentYear] - 1;
    
    NSUInteger lastMonth;
    NSUInteger lastYear;    //上一个月份所对应的年份，可能是上一年，也可能是当前年
    NSUInteger lastTotalDay;
    
    NSUInteger nextMonth;
    NSUInteger nextYear;    //下一个月份所对应的年份，可能是下一年，也可能是当前年
    NSUInteger nextTotalDay;
    
    
    if (currentMonth == 1)
    {
        lastMonth = 12; //上一年12月
        nextMonth = 2;
        
        lastYear  = currentYear - 1;
        nextYear  = currentYear;
    }
    else if (currentMonth == 12)
    {
        lastMonth = 11;
        nextMonth = 1;   //下一年1月
        
        lastYear  = currentYear;
        nextYear  = currentYear + 1;
    }
    else
    {
        lastMonth = currentMonth - 1;
        nextMonth = currentMonth + 1;
        
        lastYear  = currentYear;
        nextYear  = currentYear;
    }
    
    lastTotalDay = [DAYUtils daysInMonth:lastMonth ofYear:lastYear];
    nextTotalDay = [DAYUtils daysInMonth:nextMonth ofYear:nextYear];
    
    //保存上周(属于工作日的)的日期
    NSUInteger lastWeekdays;
    
    
    if (currentWeekday == 0 ||
        currentWeekday == 6)    //这周已经到双休了，应该先保存这周工作日的会议
    {
        lastWeekdays = 5;
    }
    else    //这周还在工作日
    {
        lastWeekdays = currentWeekday - 1;
    }
    
    /////////////////往前遍历
    for (NSUInteger i = currentDay - 1; i >= 1; i--)  //从今天往前循环，直到 1 号，不包括今天
    {
        NSUInteger weekday = [DAYUtils weekdataInMonth:currentMonth ofDay:i ofYear:currentYear] - 1;
        if (weekday == 6 ||
            weekday == 0)
        {
            continue ;
        }
        
        if (fifthDaysArr.count == lastWeekdays)   //达到上月属于本周工作日的天数，则停止循环
        {
            break;
        }
        
        NSDateComponents *compts = [[NSDateComponents alloc] init];
        compts.month = currentMonth;
        compts.day   = i;
        [fifthDaysArr insertObject:compts atIndex:0];   //保存日期
    }
    
    if (fifthDaysArr.count < lastWeekdays)  //如果循环到了 1 号还没有满 5 天，则需要遍历上一个月
    {
        for (NSUInteger i = lastTotalDay; i >= 1; i--)  //上月的从月底开始循环
        {
            NSUInteger weekday = [DAYUtils weekdataInMonth:lastMonth ofDay:i ofYear:lastYear] - 1;
            if (weekday == 6 ||
                weekday == 0)
            {
                continue ;
            }
            
            if (fifthDaysArr.count == lastWeekdays)   //达到上月属于本周工作日的天数，则停止循环
            {
                break;
            }
            
            NSDateComponents *compts = [[NSDateComponents alloc] init];
            compts.month = lastMonth;
            compts.day   = i;
            [fifthDaysArr insertObject:compts atIndex:0];   //保存日期
        }
    }
    
    NSString *des = [NSString stringWithFormat:@"逻辑错误，这里应该存满%ld天", (unsigned long)lastWeekdays];
    BOOL condition = (fifthDaysArr.count == lastWeekdays);
    NSAssert(condition, des);
    
    /////////////////往后遍历
    for (NSUInteger i = currentDay; i <= currentTotalDays; i++) //从今天开始往后循环，直到 本月最后一天
    {
        NSUInteger weekday = [DAYUtils weekdataInMonth:currentMonth ofDay:i ofYear:currentYear] - 1;
        if (weekday == 6 ||
            weekday == 0)   //跳过周六和周日
        {
            continue ;
        }
        
        if (fifthDaysArr.count == 15)   //达到15天则跳出循环
        {
            break;
        }
        
        NSDateComponents *compts = [[NSDateComponents alloc] init];
        compts.month = currentMonth;
        compts.day   = i;
        [fifthDaysArr addObject:compts];    //保存日期
    }
    
    if (fifthDaysArr.count < 15)    //当月已遍历完，还不满15天，则去下一个月循环
    {
        for (NSUInteger i = 1; i <= nextTotalDay; i++)
        {
            NSUInteger weekday = [DAYUtils weekdataInMonth:nextMonth ofDay:i ofYear:nextYear] - 1;
            if (weekday == 6 ||
                weekday == 0)
            {
                continue ;
            }
            
            if (fifthDaysArr.count == 15)   //达到15天则跳出循环
            {
                break;
            }
            
            NSDateComponents *compts = [[NSDateComponents alloc] init];
            compts.month = nextMonth;
            compts.day   = i;
            [fifthDaysArr addObject:compts];    //保存日期
        }
    }

    NSAssert(fifthDaysArr.count == 15, @"逻辑错误，这里应该存满15天");

    return (NSArray *)fifthDaysArr;
}



+ (void)makePhone:(NSString *)phoneStr
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:
     [NSURLRequest requestWithURL:
      [NSURL URLWithString:
       [NSString stringWithFormat:@"tel://%@", phoneStr]
       ]]];
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

+(BOOL)alertTipInMeeting
{
    BOOL isMeeting = [M8UserDefault getIsInMeeting];
    
    if (isMeeting)
    {
        [AlertHelp alertWith:@"温馨提示"
                     message:@"正在会议中，请先结束会议"
                   cancelBtn:@"确定"
                  alertStyle:UIAlertControllerStyleAlert
                cancelAction:nil];
    }
    
    return isMeeting;
}



+(NSString *)getDateStrWithTime:(NSTimeInterval)time
{
    return [self getDateStrWithTime:time formatter:@"yyyy-MM-dd HH:mm:ss"];
}


+ (NSString *)getRecordDateStr:(NSTimeInterval)time
{
    NSString *recordDateStr;
    
    NSDate *todayDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateComponents *curComps = [DAYUtils dateComponentsFromDate:todayDate];
    
    NSUInteger curYear  = curComps.year;
    NSUInteger curMonth = curComps.month;
    NSUInteger curDay   = curComps.day;
    NSUInteger curWeek  = [DAYUtils curWeekdayComponents:curComps];     // 1 ~ 7
    
    
    NSDate *recordDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateComponents *recComps = [DAYUtils dateComponentsFromDate:recordDate];
    
    NSUInteger recYear  = recComps.year;
    NSUInteger recMonth = recComps.month;
    NSUInteger recDay   = recComps.day;
    NSUInteger recWeek  = [DAYUtils curWeekdayComponents:recComps];     // 1 ~ 7
    NSUInteger recTotalDaysInMonth = [DAYUtils daysInMonth:recMonth ofYear:recYear];
    
    /// 计算昨天和今天
    if (curYear  == recYear)    //年
    {
        if (curMonth == recMonth)   //月
        {
            if (curDay == recDay)   //日
            {
                recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterDay];     //今天
            }
            else if (curDay == recDay + 1)
            {
                recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterLday];    //昨天
                return [@"昨天" stringByAppendingString:[NSString stringWithFormat:@"-%@", recordDateStr]];
            }
            else if ((curWeek - recWeek) == (curDay - recDay))  //判断是不是当前星期
            {
                recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterWeak];    //本周
                return [[DAYUtils stringOfWeekdayInChinese:recWeek - 1] stringByAppendingString:[NSString stringWithFormat:@"-%@", recordDateStr]];
            }
            else
            {
                recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterMonth];
            }
        }
        else if (curMonth == recMonth + 1)  //上月的信息
        {
            if (curDay == 1)    //判断今天是不是月初
            {
                if (recDay == recTotalDaysInMonth)  //判断记录时间是不是上月月底
                {
                    recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterLday];    //昨天
                    return [@"昨天 " stringByAppendingString:[NSString stringWithFormat:@"-%@", recordDateStr]];
                }
                else if ((curWeek - recWeek) == (curDay - recDay + recTotalDaysInMonth))  //判断是不是本周
                {
                    recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterWeak];    //本周
                    return [[DAYUtils stringOfWeekdayInChinese:recWeek - 1] stringByAppendingString:[NSString stringWithFormat:@"-%@", recordDateStr]];
                }
                else
                {
                    recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterMonth];
                }
            }
            else if ((curWeek - recWeek) == (curDay - recDay + recTotalDaysInMonth))  //判断是不是当前星期 (上月不是1号，上月的记录就不可能是昨天的了)
            {
                recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterWeak];    //本周
                return [[DAYUtils stringOfWeekdayInChinese:recWeek - 1] stringByAppendingString:[NSString stringWithFormat:@"-%@", recordDateStr]];
            }
            else
            {
                recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterMonth];
            }
        }
        else    //其他月份
        {
            recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterMonth];
        }
    }
    else    //其他年份
    {
        recordDateStr = [self getDateStrWithTime:time formatter:kTimeformatterYear];
    }
    
    
    return recordDateStr;
}

/**
 设置时间格式

 @param time 时间戳
 @param formatterStr 格式字符串
 @return 对应的时间格式字符串
 */
+ (NSString *)getDateStrWithTime:(NSTimeInterval)time formatter:(NSString *)formatterStr
{
    NSString *timeStr;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    timeStr = [formatter stringFromDate:startDate];
    return timeStr;
}

// 文字模糊背景
// 默认：白色文字、黑色模糊
// 文字大小 16
+(NSMutableAttributedString *)getShadowStr:(NSString *)str
{
    return [self getShadowStr:str
                         font:[UIFont systemFontSize]
            ];
}

+(NSMutableAttributedString *)getShadowStr:(NSString *)str font:(CGFloat)font
{
    return [self getShadowStr:str
                         font:font
                    textColor:[UIColor whiteColor]
                  shadowColor:[UIColor blackColor]];
}

+(NSMutableAttributedString *)getShadowStr:(NSString *)str
                                      font:(CGFloat)font
                                 textColor:(UIColor *)textColor
                               shadowColor:(UIColor *)shadowColor
{
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
+(NSMutableAttributedString *)customAttString:(NSString *)string
{
    return [self customAttString:string
                        fontSize:0
            ];
}


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
    if (string &&
        [string isKindOfClass:[NSString class]])
        return [[NSMutableAttributedString alloc] initWithString:string
                                                      attributes:[self customAttsWithFontSize:fontSize
                                                                                    textColor:textColor
                                                                                    charSpace:charSpace
                                                                  ]
                ];
    return nil;
//    return [self customAttString:string
//                        fontSize:fontSize
//                       textColor:textColor
//                       charSpace:charSpace
//                        fontName:nil];
}


//+(NSMutableAttributedString *)customAttString:(NSString *)string
//                                     fontSize:(CGFloat)fontSize
//                                    textColor:(UIColor *)textColor
//                                    charSpace:(int)charSpace
//                                     fontName:(NSString *)fontName
//{
//    if (string &&
//        [string isKindOfClass:[NSString class]])
//        return [[NSMutableAttributedString alloc] initWithString:string
//                                                      attributes:[self customAttsWithFontSize:fontSize
//                                                                                    textColor:textColor
//                                                                                    charSpace:charSpace
//                                                                                     fontName:fontName]];
//    return nil;
//}

#pragma mark - 文本属性
#pragma mark -- 粗文本属性
+(NSMutableDictionary *)customAttsWithBodyFontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //设置字体-粗体、大小
    [attDict setValue:[UIFont boldSystemFontOfSize:fontSize] forKey:NSFontAttributeName];
    //设置字体颜色
    if (textColor)
        [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
    return attDict;
}
#pragma mark --
+(NSMutableDictionary *)customAttsWithFontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor
                                     charSpace:(int)charSpace
{
    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    CGFloat curFontSize;
    if (fontSize)   //设置字体、大小
        curFontSize = fontSize;
    else
        curFontSize = kAppMiddleFontSize;
    
    [attDict setValue:[UIFont fontWithName:kFontNameSTHeiti_Light size:curFontSize] forKey:NSFontAttributeName];
    
    if (textColor)  //设置字体颜色
        [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
    
    if (charSpace)  //设置字符间距
        [attDict setValue:@(charSpace) forKey:NSKernAttributeName];
    
    return attDict;
}



//+(NSMutableDictionary *)customAttsWithFontSize:(CGFloat)fontSize
//                                     textColor:(UIColor *)textColor
//                                     charSpace:(int)charSpace
//{
//    return [self customAttsWithFontSize:fontSize
//                              textColor:textColor
//                              charSpace:charSpace
//                               fontName:kFontNameSTHeiti_Light
//            ];
//}
//+(NSMutableDictionary *)customAttsWithFontSize:(CGFloat)fontSize
//                                     textColor:(UIColor *)textColor
//                                     charSpace:(int)charSpace
//                                      fontName:(NSString *)fontName
//{
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    //设置字体、大小
//    if (fontName && fontSize)
//        [attDict setValue:[UIFont fontWithName:fontName size:fontSize] forKey:NSFontAttributeName];
//    //设置字体颜色
//    if (textColor)
//        [attDict setValue:textColor forKey:NSForegroundColorAttributeName];
//    //设置字符间距
//    if (charSpace)
//        [attDict setValue:@(charSpace) forKey:NSKernAttributeName];
//    return attDict;
//}


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
