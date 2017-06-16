//
//  M8CallHeaderView.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * _Nonnull kHeaderAction = @"kHeaderAction";
static NSString * _Nonnull kHeaderText   = @"kHeaderText";


@protocol MeetHeaderDelegate <NSObject>

- (void)MeetHeaderActionInfo:(NSDictionary *_Nullable)actionInfo;

@end


/**
 头部标题视图
 
    * 整体界面缩放 -- 点击之后会缩放到一个小窗口事件，回到上一个界面
    * 会议主题
    * 会议时长
 */
@interface M8CallHeaderView : UIView

@property (nonatomic, weak) id<MeetHeaderDelegate> _Nullable WCDelegate;

/**
 设置会议主题

 @param topic 会议主题
 */
- (void)configTopic:(NSString *_Nonnull)topic;


/**
 开始计时
 */
- (void)beginCountTime;

@end
