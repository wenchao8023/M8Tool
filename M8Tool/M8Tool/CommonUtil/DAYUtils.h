//
//  DAYUtils.h
//  M8Tool
//
//  Created by chao on 2017/8/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAYUtils : NSObject

+ (NSCalendar *)localCalendar;

+ (NSDate *)dateWithMonth:(NSUInteger)month year:(NSUInteger)year;

+ (NSDate *)dateWithMonth:(NSUInteger)month day:(NSUInteger)day year:(NSUInteger)year;

+ (NSDate *)dateFromDateComponents:(NSDateComponents *)components;

+ (NSUInteger)daysInMonth:(NSUInteger)month ofYear:(NSUInteger)year;

+ (NSUInteger)firstWeekdayInMonth:(NSUInteger)month ofYear:(NSUInteger)year;

+ (NSUInteger)weekdataInMonth:(NSUInteger)month ofDay:(NSUInteger)day ofYear:(NSUInteger)year;

+ (NSUInteger)curWeekdayComponents:(NSDateComponents *)components;

+ (NSString *)stringOfWeekdayInEnglish:(NSUInteger)weekday;

+ (NSString *)stringOfWeekdayInChinese:(NSUInteger)weekday;

+ (NSString *)stringOfMonthInEnglish:(NSUInteger)month;

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

+ (BOOL)isDateTodayWithDateComponents:(NSDateComponents *)dateComponents;


@end
