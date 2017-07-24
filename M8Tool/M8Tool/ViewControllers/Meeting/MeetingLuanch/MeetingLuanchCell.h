//
//  MeetingLuanchCell.h
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MeetingLuanchCell : UITableViewCell

@property (nonatomic, copy, nullable) M8VoidBlock onCollectMeetBlock;  //收藏会议
@property (nonatomic, copy, nullable) M8VoidBlock onCancelMeetBlock;   //取消收藏会议

- (void)configWithItem:(NSString *_Nullable)item content:(NSString *_Nullable)content;

- (void)configWithItem:(NSString *_Nullable)item content:(NSString *_Nullable)content isCollect:(BOOL)isCollect;

- (void)configWithTageArray:(NSArray *_Nullable)tagsArray;

@end
