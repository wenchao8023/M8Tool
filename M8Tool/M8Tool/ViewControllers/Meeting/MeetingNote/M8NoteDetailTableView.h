//
//  M8NoteDetailTableView.h
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 两种cell
    第一种是和发起界面的cell类似
    第二种是笔记缩略或者是详情 -- 展开看全文，只刷新对应的cell
 */
@interface M8NoteDetailTableView : UITableView

- (instancetype _Nonnull)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataModel:(id _Nonnull)model;

- (void)shareAction;
@end
