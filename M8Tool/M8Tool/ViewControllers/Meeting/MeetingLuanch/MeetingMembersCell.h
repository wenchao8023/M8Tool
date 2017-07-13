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
 **
 *
 *  也可以是会议详情下面的成员
 */
@interface MeetingMembersCell : UICollectionViewCell

#pragma mark - 配置 参会人员
- (void)configMeetingMembersWithNameStr:(NSString *_Nullable)nameStr isDeling:(BOOL)isDeling ;
// 添加和删除的图片
- (void)configMeetingMembersWithImageStr:(NSString *_Nullable)imageStr ;

#pragma mark - 配置 最近联系人
//- (void)configLatestMembersWithNameStr:(NSString *_Nonnull)nameStr isSelected:(BOOL)isSelected ;
- (void)configLatestMembersWithNameStr:(NSString *_Nullable)nameStr isSelected:(BOOL)isSelected radiusBorder:(CGFloat)radius ;

#pragma mark - 配置 会议详情
- (void)configRecordDetailWithNameStr:(NSString *_Nullable)nameStr radiusBorder:(CGFloat)radius ;
@end
