//
//  M8CallHeaderView.h
//  M8Tool
//
//  Created by chao on 2017/6/8.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>




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
 配置头部视图信息

 @param item item
 */
//- (void)configHeaderView:(TCShowLiveListItem *_Nonnull)item;

/**
 配置头部视图信息

 @param title 会议主题
 @param nick 发起人昵称
 */
- (void)configHeaderView:(NSString *_Nullable)title hostNick:(NSString *_Nullable)nick;

@end
