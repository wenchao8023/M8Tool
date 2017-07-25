//
//  M8CallNoteModel.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallNoteModel.h"

@implementation M8CallNoteModel

- (instancetype)initWithTip:(NSString *)tipInfo
{
    if (self = [super init])
    {
        _tipInfo = tipInfo;
    }
    
    return self;
}

- (instancetype)initWithMember:(NSString *)member Tip:(NSString *)tipInfo
{
    if (self = [super init])
    {
        _name    = member;
        _tipInfo = tipInfo;
    }
    
    return self;
}
@end
