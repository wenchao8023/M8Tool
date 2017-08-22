//
//  DeleteInfoRequest.m
//  M8Tool
//
//  Created by chao on 2017/7/24.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "DeleteInfoRequest.h"

@implementation DeleteInfoRequest

@end


@implementation DeleteCompanyReuqest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=deletecompany", self.hostUrl];
}


- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"uid"     : _uid,
             @"cid"     : @(_cid)
             };
}

@end


@implementation DeleteDepartmentReuqest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=company&cmd=deletedepartment", self.hostUrl];
}


- (NSDictionary *)packageParams
{
    return @{
             @"token"   : _token,
             @"uid"     : _uid,
             @"did"     : @(_did)
             };
}

@end


@implementation DeleteFriendReuqest

- (NSString *)url
{
    return [NSString stringWithFormat:@"%@svc=account&cmd=deleteFriend", self.hostUrl];
}


- (NSDictionary *)packageParams
{
    return @{
             @"token"  : _token,
             @"id"     : _uid,
             @"frd_id" : _fid
             };
}

@end
