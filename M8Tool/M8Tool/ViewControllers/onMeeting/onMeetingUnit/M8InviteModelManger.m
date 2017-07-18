//
//  M8InviteModelManger.m
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8InviteModelManger.h"


static M8InviteModelManger *shareInstance = nil;

@implementation M8InviteModelManger

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[M8InviteModelManger alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.selectMemberArray = [NSMutableArray arrayWithCapacity:0];
        self.inviteMemberArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}


- (BOOL)isExistInviteArray:(NSString *)uid
{
    return [self user:uid isExistInArray:self.inviteMemberArray];
}


- (BOOL)isExistSelectArray:(NSString *)uid
{
    return [self user:uid isExistInArray:self.selectMemberArray];
}


- (void)updateInviteMemberArray:(NSArray *)currentArray
{
    [self.inviteMemberArray removeAllObjects];
    [self.inviteMemberArray addObjectsFromArray:currentArray];
}

- (void)onSelectAtMemberInfo:(M8MemberInfo *)member
{
    if ([self user:member.uid isExistInArray:self.selectMemberArray])
    {
        [self removeUserFromSelectArray:member.uid];
    }
    else
    {
        [self.selectMemberArray addObject:member];
    }
}

- (void)removeUserFromSelectArray:(NSString *)uid
{
    for (int i = 0; i < self.selectMemberArray.count; i++)
    {
        M8MemberInfo *info = self.selectMemberArray[i];
        if ([info.uid isEqualToString:uid])
        {
            [self.selectMemberArray removeObject:info];
            break;
        }
    }
}

- (BOOL)user:(NSString *)uid isExistInArray:(NSArray *)arr
{
    for (M8MemberInfo *info in arr)
    {
        if ([info.uid isEqualToString:uid])
        {
            return YES;
        }
    }
    
    return NO;
}

@end
