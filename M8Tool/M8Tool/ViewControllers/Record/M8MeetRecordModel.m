//
//  M8MeetRecordModel.m
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetRecordModel.h"


@implementation M8MeetMemberInfo


- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self setMyValue:self.user key:@"user" inDic:dic];
    [self setMyValue:self.statu key:@"statu" inDic:dic];
    [self setMyValue:self.entertime key:@"entertime" inDic:dic];
    [self setMyValue:self.exittime key:@"exittime" inDic:dic];
    [self setMyValue:self.nick key:@"nick" inDic:dic];

    return (NSDictionary *)dic;
}

- (void)setMyValue:(id)value key:(NSString *)key inDic:(NSMutableDictionary *)dic
{
    if (value)
    {
        [dic setValue:value forKey:key];
    }
    else
    {
        [dic setValue:[NSNull null] forKey:key];
    }
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation M8MeetRecordModel

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self setMyValue:self.mid key:@"mid" inDic:dic];
    [self setMyValue:self.title key:@"title" inDic:dic];
    [self setMyValue:self.mainuser key:@"mainuser" inDic:dic];
    [self setMyValue:self.type key:@"type" inDic:dic];
    [self setMyValue:self.starttime key:@"starttime" inDic:dic];
    [self setMyValue:self.endtime key:@"endtime" inDic:dic];
    [self setMyValue:@(self.collect) key:@"collect" inDic:dic];
    
    NSMutableArray *memArr = [NSMutableArray arrayWithCapacity:0];
    for (M8MeetMemberInfo *info in self.members)
    {
        NSDictionary *infoDic = [info toDictionary];
        [memArr addObject:infoDic];
    }
    
    [self setMyValue:memArr key:@"members" inDic:dic];
    
    return (NSDictionary *)dic;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setMyValue:(id)value key:(NSString *)key inDic:(NSMutableDictionary *)dic
{
    if (value)
    {
        [dic setValue:value forKey:key];
    }
    else
    {
        [dic setValue:[NSNull null] forKey:key];
    }
}

@end
