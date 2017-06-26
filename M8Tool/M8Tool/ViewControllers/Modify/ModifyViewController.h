//
//  ModifyViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 用于修改信息、文本、时间、日期等类型
 */
typedef enum : NSUInteger {
    Modify_text,
    Modify_time,
    Modify_date,
} ModifyType;



@protocol ModifyViewDelegate <NSObject>

@optional

/**
 修改信息代理方法
 
 @param modifyInfo 修改的信息
 */
- (void)modifyViewMofifyInfo:(NSDictionary *_Nonnull)modifyInfo ;

/**
 修改信息代理方法
 
 @param modifyInfo 修改的信息
 @param indexPath 对应 tableView 的下标
 */
- (void)modifyViewMofifyInfo:(NSDictionary *_Nonnull)modifyInfo indexPath:(NSIndexPath *_Nonnull)indexPath;

@end



@interface ModifyViewController : UIViewController

@property (nonatomic, assign) ModifyType modifyType;

@property (nonatomic, weak) id _Nullable WCDelegate;

@property (nonatomic, copy, nullable) NSString *originContent;

@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

@property (nonatomic, copy, nullable) NSString *naviTitle;

@end
