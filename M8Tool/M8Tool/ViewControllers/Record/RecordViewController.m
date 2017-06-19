//
//  RecordViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/11.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableView.h"


@interface RecordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) RecordTableView *tableView;

@end

@implementation RecordViewController
@synthesize _searchView;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_recordViewType == RecordViewType_note ||
        _recordViewType == RecordViewType_collect) {
        
        // 添加 搜索视图
        [self addSearchView];
        
        // 重新设置内容视图 >> 添加 tableView
        [self resetContentView];
    }
    
    [self.contentView addSubview:self.tableView];
}

- (RecordTableView *)tableView {
    if (!_tableView) {
        RecordTableView *tabelView = [[RecordTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        tabelView.recordViewType = self.recordViewType;
        _tableView = tabelView;
    }
    return _tableView;
}

- (void)addSearchView {
    CGRect frame = self.contentView.frame;
    frame.size.height = kSearchView_height;
    BaseSearchView *searchView = [[BaseSearchView alloc] initWithFrame:frame target:self];
    WCViewBorder_Radius(searchView, kSearchView_height / 2);
    searchView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:(_searchView = searchView)];
}

- (void)resetContentView {
    CGFloat originY = CGRectGetMaxY(_searchView.frame) + kMarginView_top;
    self.contentView.y = originY;
    self.contentView.height = self.contentView.height - originY + kDefaultNaviHeight;
}

#pragma mark - 判断视图类型
- (NSString *)getTitle {
    switch (self.recordViewType) {
        case RecordViewType_record:
            return @"会议记录";
            break;
        case RecordViewType_note:
            return @"会议笔记";
            break;
        case RecordViewType_collect:
            return @"会议收藏";
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
