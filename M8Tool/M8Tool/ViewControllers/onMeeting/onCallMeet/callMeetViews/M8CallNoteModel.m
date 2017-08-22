//
//  M8CallNoteModel.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallNoteModel.h"

@implementation M8CallNoteModel



- (instancetype)initWithMember:(NSString *)member tip:(NSString *)tip
{
    if (self = [super init])
    {
        _name    = member;
        _tipInfo = tip;
    }
    
    return self;
}

- (instancetype)initWithMember:(NSString *)member msg:(NSString * _Nullable)msg
{
    if (self = [super init])
    {
        _name    = member;
        _msgInfo = msg;
    }
    
    return self;
}
@end
