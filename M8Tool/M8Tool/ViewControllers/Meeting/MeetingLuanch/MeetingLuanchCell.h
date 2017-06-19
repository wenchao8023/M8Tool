//
//  MeetingLuanchCell.h
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordModel;

@interface MeetingLuanchCell : UITableViewCell

- (void)configWithItem:(NSString *)item content:(NSString *)content;

- (void)configWithItem:(NSString *)item content:(NSString *)content imageName:(NSString *)imageName;

- (void)configWithTageArray:(NSArray *_Nonnull)tagsArray;

@end
