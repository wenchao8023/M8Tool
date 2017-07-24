//
//  MeetingLuanchTableView.h
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LuanchTableViewDelegate <NSObject>

/**
 会议主题

 @param topic 会议主题
 */
- (void)luanchTableViewMeetingTopic:(NSString *_Nonnull)topic;


/**
 直播中的的封面图

 @param coverImg 图片
 */
- (void)luanchTableViewMeetingCoverImg:(UIImage *_Nonnull)coverImg;


/**
 通话成员
 
 @param currentMembers 返回给VC的是 @[@(uid)]
 */
- (void)luanchTableViewMeetingCurrentMembers:(NSArray *_Nonnull)currentMembers;

@end




@interface MeetingLuanchTableView : UITableView

/**
 *  隐藏的时候表示 发起直播会议
 */
@property (nonatomic, assign) BOOL isHiddenFooter;

@property (nonatomic, assign) NSInteger MaxMembers;

@property (nonatomic, weak) id _Nullable WCDelegate;


- (void)shouldReloadDataFromSelectContact:(M8VoidBlock _Nullable )succHandle;

- (void)loadDataWithLuanchCall;

@end
