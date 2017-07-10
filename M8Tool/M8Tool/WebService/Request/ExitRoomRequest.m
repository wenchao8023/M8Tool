//
//  ExitRoomRequest.m
//  TILLiveSDKShow
//
//  Created by wilderliao on 16/12/9.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "ExitRoomRequest.h"

@implementation ExitRoomRequest

- (NSString *)url
{
    NSString *host = [self hostUrl];
    return [NSString stringWithFormat:@"%@svc=live&cmd=exitroom",host];
}

- (NSDictionary *)packageParams
{
    NSDictionary *dic = @{
                          @"token"      : _token,
                          @"roomnum"    : [NSNumber numberWithInteger:_roomnum],
                          @"type"       : _type,
                          @"mid"        : @(_mid)
                          };
    return dic;
}

@end
