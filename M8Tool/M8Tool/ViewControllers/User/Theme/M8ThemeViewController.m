//
//  M8ThemeViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8ThemeViewController.h"

#import "M8ThemeCell.h"
#import "M8ThemeDetailViewController.h"



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
        tableView.delegate        = self;
        tableView.dataSource      = self;
        tableView.backgroundColor = WCClear;
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
    
    NSArray *imgsArr = @[@"灰白", @"灰蓝", @"淡青", @"木纹", @"栅格红"];
    for (NSString *imgStr in imgsArr) {
        M8ThemeModel *model = [M8ThemeModel new];
        model.imgStr = [NSString stringWithFormat:@"%@preview", imgStr];
        model.nameStr = imgStr;
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    M8ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"M8ThemeCellID" forIndexPath:indexPath];
    
    M8ThemeModel *model = self.dataArray[indexPath.row];
    [cell config:model isCurrentTheme:[model.nameStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage]]];
    
    return cell;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentView.height * 2 / 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    M8ThemeModel *model = self.dataArray[indexPath.row];
    M8ThemeDetailViewController *detailVC = [[M8ThemeDetailViewController alloc] init];
    detailVC.isExitLeftItem = YES;
    detailVC.headerTitle    = model.nameStr;
    detailVC.imageStr       = model.imgStr;
    [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
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
