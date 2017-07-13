//
//  M8MeetListCache.m
//  M8Tool
//
//  Created by chao on 2017/7/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetListCache.h"

#import "M8MeetListModel.h"


@implementation M8MeetListCache

+ (void)addMeetListToLocal:(NSArray *)dataArray
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    
    if (dataArray.count)
    {
        NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
        
        for (M8MeetListModel *model in dataArray)
        {
            NSDictionary *modelDic = [model toDictionary];
            [modelArray addObject:modelDic];
        }
        
        [userD setObject:(NSArray *)modelArray forKey:kMeetList];
    }
    else    //移除数据
    {
        [userD removeObjectForKey:kMeetList];
    }
    
    [userD synchronize];
}

+ (M8MeetListModel *)topModelFromLocalMeetList
{
    NSArray *modelArray = [self localMeetList];
    if (modelArray && modelArray.count)
    {
        M8MeetListModel *topModel = [modelArray firstObject];
        return topModel;
    }
    else
    {
        return nil;
    }
}

+ (NSArray *)localMeetList
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *modelArray = [userD objectForKey:kMeetList];
    if (modelArray && modelArray.count)
    {
        return modelArray;
    }
    else
    {
        return nil;
    }
    
}




@end
