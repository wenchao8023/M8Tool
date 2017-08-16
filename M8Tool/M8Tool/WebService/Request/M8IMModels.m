//
//  M8IMModels.m
//  M8Tool
//
//  Created by chao on 2017/7/1.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8IMModels.h"

@implementation M8IMModels

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation M8FriendInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation M8MemberInfo

- (instancetype)initWithTIMUserProfile:(TIMUserProfile *)userProfile
{
    if (self = [super init])
    {
        self.uid  = userProfile.identifier;
        self.nick = userProfile.nickname;
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}




@end




@implementation M8DepartmentInfo

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}


@end



@implementation M8CompanyInfo

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

@end
