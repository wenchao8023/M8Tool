//
//  M8LiveJoinTableView.m
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveJoinTableView.h"

@interface M8LiveJoinTableView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation M8LiveJoinTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *joinCellID = @"joinTableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:joinCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:joinCellID];
    }
    
    cell.backgroundColor = WCRandomColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
#warning 这里可以设置childVC的位置
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
#warning 这里判断停止拖动之后是还原还是切换
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
#warning 如果切换了，这里需要重新加载childVC
}


- (void)reloadData {
    [super reloadData];
    
    // cell 加载完成之后，计算当前视图中的cell
}

@end
