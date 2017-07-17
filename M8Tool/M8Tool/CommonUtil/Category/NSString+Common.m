//
//  NSString+Common.h
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//


#import "NSString+Common.h"

@implementation NSString (Common)

- (NSString *)getSimpleName
{
    if (self.length <= 2)
    {
        return self;
    }
    else
    {
        return [self substringFromIndex:self.length - 2];
    }
}

//判断是否是邮箱
-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
//手机号码验证
-(BOOL)validateMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//判断一个字符串是否是url
-(BOOL)validateUrl
{
    NSRegularExpression *regularexpressionURL = [[NSRegularExpression alloc]
                                                 
                                                 initWithPattern:@"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
                                                 
                                                 options:NSRegularExpressionCaseInsensitive
                                                 
                                                 error:nil];
    
    NSUInteger numberofMatchURL = [regularexpressionURL numberOfMatchesInString:self
                                   
                                                                        options:NSMatchingReportProgress
                                   
                                                                          range:NSMakeRange(0, self.length)];
    if(numberofMatchURL > 0)
    {
        return YES;
    }
    return NO;
}
//判断一段字符串是不是纯数字
-(BOOL)validateNumText
{
    
    if ([[self stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    
}


@end
