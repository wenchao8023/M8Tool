//
//  M8MeetListModel.h
//  M8Tool
//
//  Created by chao on 2017/5/12.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M8MeetListModel : NSObject

@property (nonatomic, copy, nullable) NSString *recordTopic;
@property (nonatomic, copy, nullable) NSString *recordLuancher;
@property (nonatomic, copy, nullable) NSString *recordType;
@property (nonatomic, copy, nullable) NSString *recordTime;
@property (nonatomic, strong, nullable) NSArray *recordMembers;
@property (nonatomic, strong, nullable) NSArray *recordTags;
@property (nonatomic, assign) BOOL isRecordCollected;

@end
