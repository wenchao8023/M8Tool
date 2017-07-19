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

#pragma mark - init
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
        
    }
    return self;
}

- (NSMutableArray *)selectMemberArray
{
    if (!_selectMemberArray)
    {
        _selectMemberArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectMemberArray;
}

- (NSMutableArray *)inviteMemberArray
{
    if (!_inviteMemberArray)
    {
        _inviteMemberArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _inviteMemberArray;
}


#pragma mark - public actions
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

- (void)removeAllMembers
{
    [self removeInviteMembers];
    [self removeSelectMembers];
}

- (void)removeInviteMembers
{
    [self.inviteMemberArray removeAllObjects];
    self.inviteMemberArray = nil;
}

- (void)removeSelectMembers
{
    [self.selectMemberArray removeAllObjects];
    self.selectMemberArray = nil;
}



#pragma mark - private actions
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
