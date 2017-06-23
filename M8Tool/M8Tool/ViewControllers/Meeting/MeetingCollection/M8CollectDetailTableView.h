//
//  M8CollectDetailTableView.h
//  M8Tool
//
//  Created by chao on 2017/6/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M8CollectDetailTableView : UITableView

- (instancetype _Nonnull)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataModel:(id _Nonnull)model;

/**
 测试 - 重新发起会议
 */
- (void)reluanch;

@end
