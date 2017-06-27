//
//  M8LiveJoinTableView.h
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LiveJoinTableViewDelegate <NSObject>

- (void)LiveJoinTableViewCurrentCellIndex:(NSInteger)index;

@end



@interface M8LiveJoinTableView : UITableView

@property (nonatomic, weak) id<LiveJoinTableViewDelegate> _Nullable WCDelegate;

@end
