//
//  M8LiveJoinViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveJoinViewController.h"

#import "M8LiveChildViewController.h"


@interface M8LiveJoinViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) M8LiveChildViewController *childVC;

@end

@implementation M8LiveJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self childVC];
    [self.view insertSubview:self.tableView belowSubview:self.childVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.directionalLockEnabled = YES;
        tableView.pagingEnabled = YES;
        _tableView = tableView;
    }
    return _tableView;
}

- (M8LiveChildViewController *)childVC {
    if (!_childVC) {
        M8LiveChildViewController *childVC = [[M8LiveChildViewController alloc] init];
        childVC.view.frame = self.view.bounds;
        childVC.view.backgroundColor = WCClear;
        [self addChildViewController:childVC];
        [self.view insertSubview:childVC.view aboveSubview:self.bgImageView];
        [childVC didMoveToParentViewController:self];
        _childVC = childVC;
    }
    return _childVC;
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
    return self.view.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
#warning 这里可以设置childVC的位置
    if ([scrollView isEqual:self.tableView]) {
        UITableViewCell *currentCell = [[self.tableView visibleCells] firstObject];
        [self.childVC updateFrameWithOffsetY:currentCell.bounds.origin.y];
    }
    
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
#warning 这里判断停止拖动之后是还原还是切换
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
#warning 如果切换了，这里需要重新加载childVC
}




@end
