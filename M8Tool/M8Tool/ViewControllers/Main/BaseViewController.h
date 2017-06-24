//
//  BaseViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSearchView.h"


typedef NS_ENUM(NSInteger, M8MeetListViewType) {
    M8MeetListViewTypeRecord = 0,       ///> 会议记录
    M8MeetListViewTypeNote,             ///> 会议笔记
    M8MeetListViewTypeCollect,          ///> 会议收藏
};


static const float kMarginView_top          = 10;
static const float kMarginView_horizontal   = 20;
static const float kRadiusView              = 10;



#define kContentOriginX         (30.5 / 375 * SCREEN_WIDTH)
//#define kContentOriginX         (30.5 / 375 * SCREEN_WIDTH)
#define kContentHeight_bottom30 (SCREEN_HEIGHT - 153)
#define kContentHeight_bottom60 (SCREEN_HEIGHT - 183)
#define kContentHeight_bottom90 (SCREEN_HEIGHT - 213)
#define kContentHeight_setting  SCREEN_HEIGHT * 180 / 667
//#define kContentHeight_bottom30 (SCREEN_HEIGHT - kDefaultNaviHeight - kDefaultTabbarHeight - kMarginView_top - 30)



@interface BaseViewController : UIViewController


/**
 会议记录中会使用到 searchView
 */
@property (nonatomic, strong, nullable) BaseSearchView *_searchView;

/**
 背景图片
 */
@property (nonatomic, strong, nullable) UIImageView *bgImageView;


/**
 头部 view
 */
@property (nonatomic, strong, nullable)     UIView *headerView;

/**
 标题名称
 */
@property (nonatomic, copy, nullable)       NSString *headerTitle;

/**
 是否存在左边的返回 view
 */
@property (nonatomic, assign)               BOOL isExitLeftItem;

/**
 内容区
 */
@property (nonatomic, strong, nullable)     UIView *contentView;

#pragma mark - 右侧按钮样式
// 文字按钮
- (void)setRightButtonTitle:(NSString *_Nonnull)title target:(id _Nonnull)target action:(SEL _Nonnull)action ;
// 图片按钮
- (void)setRightButtonImage:(NSString * _Nonnull)imgStr target:(id _Nonnull)target action:(SEL _Nonnull)action ;

@end
