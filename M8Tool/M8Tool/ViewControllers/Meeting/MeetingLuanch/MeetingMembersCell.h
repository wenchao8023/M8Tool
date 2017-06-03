//
//  MeetingMembersCell.h
//  M8Tool
//
//  Created by chao on 2017/5/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *  1.显示参会人员
 *  2.显示最近联系人-未选择
 *  3.显示最近联系人-已选择
 */
@interface MeetingMembersCell : UICollectionViewCell

#pragma mark - 配置 参会人员
- (void)configMeetingMembersWithNameStr:(NSString *)nameStr isDeling:(BOOL)isDeling ;
- (void)configMeetingMembersWithImageStr:(NSString *)imageStr ;

#pragma mark - 配置 最近联系人
- (void)configLatestMembersWithNameStr:(NSString *)nameStr isSelected:(BOOL)isSelected ;
@end
