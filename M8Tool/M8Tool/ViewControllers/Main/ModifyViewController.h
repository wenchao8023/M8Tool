//
//  ModifyViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "BaseViewController.h"



@protocol ModifyViewDelegate <NSObject>

- (void)modifyViewMofifyInfo:(NSDictionary *_Nonnull)modifyInfo ;

@end


/**
 用于修改信息、文本、时间、日期等类型
 */
typedef enum : NSUInteger {
    Modify_text,
    Modify_time,
    Modify_date,
} ModifyType;
@interface ModifyViewController : BaseViewController

@property (nonatomic, assign) ModifyType modifyType;

@property (nonatomic, weak) id _Nullable WCDelegate;

@property (nonatomic, copy, nullable) NSString *originContent;

@end
