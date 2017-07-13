//
//  MeetingLuanchCell.h
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MeetingLuanchCell : UITableViewCell

- (void)configWithItem:(NSString *_Nonnull)item content:(NSString *_Nonnull)content;

//- (void)configWithItem:(NSString *_Nullable)item content:(NSString *_Nullable)content imageName:(NSString *_Nullable)imageName;

- (void)configWithTageArray:(NSArray *_Nonnull)tagsArray;

@end
