//
//  M8InviteModelManger.m
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8InviteModelManger.h"

#import "M8CallRenderModel.h"


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

- (NSString *)nickInInviteArray:(NSString *)uid
{
    if ([self isExistInviteArray:uid])
    {
        return [self nickInInviteArrayWithUid:uid];
    }
    return nil;
}

- (void)mergeSelectToInvite
{
    [self.inviteMemberArray addObjectsFromArray:self.selectMemberArray];
    [self removeSelectMembers];
}


- (void)updateInviteM8CallRenderModelArray:(NSArray *)callRenderModelArr
{
    NSMutableArray *tempInviteArr = [NSMutableArray arrayWithCapacity:0];
    
    for (M8CallRenderModel *model in callRenderModelArr)
    {
        M8MemberInfo *info = [[M8MemberInfo alloc] init];
        info.uid = model.identify;
        info.nick = model.nick;
        [tempInviteArr addObject:info];
    }
    
    [self updateInviteMemberArray:tempInviteArr];
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

//调用此方法之前要先判断用户是否存在 inviteArray
- (NSString *)nickInInviteArrayWithUid:(NSString *)uid
{
    for (M8MemberInfo *mInfo in self.inviteMemberArray)
    {
        if ([mInfo.uid isEqualToString:uid])
        {
            return mInfo.nick;
            break;
        }
    }
    
    NSAssert(1, @"数组中一定要有成员");
    
    return nil;
}


@end
