//
//  M8MeetHeaderView.h
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
 
    * 整体界面缩放
    * 会议主题
    * 会议时长
 */
@interface M8MeetHeaderView : UIView

@property (nonatomic, assign) BOOL isLarge;

@end
