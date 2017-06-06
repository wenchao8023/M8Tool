//
//  M8ThemeViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8ThemeViewController.h"

#import "M8ThemeCell.h"


@interface M8ThemeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
    
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation M8ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setHeaderTitle:@"主题"];
    
    [self createUI];
    
    [self loadData];
}
    
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = [WCUIKitControl createViewWithFrame:CGRectZero];
        tableView.tableFooterView = [WCUIKitControl createViewWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"M8ThemeCell" bundle:nil] forCellReuseIdentifier:@"M8ThemeCellID"];
        _tableView = tableView;
    }
    return _tableView;
}
    
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
        _dataArray = dataArray;
    }
    return _dataArray;
}
    
    
- (void)createUI {
    
    [self.contentView addSubview:self.tableView];
}

- (void)loadData {
    
    M8ThemeModel *model1 = [M8ThemeModel new];
    model1.imgStr = @"";
    model1.nameStr = @"灰";
    [self.dataArray addObject:model1];
    
    M8ThemeModel *model2 = [M8ThemeModel new];
    model2.imgStr = @"";
    model2.nameStr = @"青";
    [self.dataArray addObject:model2];
    
    M8ThemeModel *model3 = [M8ThemeModel new];
    model3.imgStr = @"";
    model3.nameStr = @"米黄";
    [self.dataArray addObject:model3];
    
    M8ThemeModel *model4 = [M8ThemeModel new];
    model4.imgStr = @"";
    model4.nameStr = @"黑";
    [self.dataArray addObject:model4];
    
    M8ThemeModel *model5 = [M8ThemeModel new];
    model5.imgStr = @"";
    model5.nameStr = @"蓝";
    [self.dataArray addObject:model5];
    
    [self.tableView reloadData];
}
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    M8ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M8ThemeCellID" forIndexPath:indexPath];
    
    [cell config:self.dataArray[indexPath.row]];
    
    return cell;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentView.height * 2 / 5;
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
