//
//  NSString+SimpleName.m
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "NSString+SimpleName.h"

@implementation NSString (SimpleName)

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

@end
