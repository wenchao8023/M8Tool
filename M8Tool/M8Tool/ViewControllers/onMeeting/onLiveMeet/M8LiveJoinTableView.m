//
//  M8LiveJoinTableView.m
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveJoinTableView.h"
#import "M8LiveJoinCell.h"

@interface M8LiveJoinTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation M8LiveJoinTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.pagingEnabled = YES;
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.scrollEnabled = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *joinCellID = @"joinTableViewCellID";
    M8LiveJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:joinCellID];
    if (!cell) {
        cell = [[M8LiveJoinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:joinCellID];
    }
    
    [cell configWithNumStr:[NSString stringWithFormat:@"%ld", indexPath.row] isVisible:(indexPath.row == _currentIndex)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = self.contentOffset.y / self.height;
    
    [self reloadData];
}


- (void)reloadData {
    [super reloadData];
    
    if ([self.WCDelegate respondsToSelector:@selector(LiveJoinTableViewCurrentCellIndex:)]) {
        [self.WCDelegate LiveJoinTableViewCurrentCellIndex:_currentIndex];
    }
}





@end
