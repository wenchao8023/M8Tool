//
//  CreateCompanyViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CreateCompanyViewController.h"



@interface CreateCompanyViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int _currentMembers;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSMutableArray *itemsArray;   //使用 M8MemberInfo 保存数据


@end



@implementation CreateCompanyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _currentMembers = 1;
    
    [self tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:@"创建团队"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)sectionsArray
{
    if (!_sectionsArray)
    {
        _sectionsArray = [NSMutableArray arrayWithCapacity:0];
        [_sectionsArray addObject:@"团队名称"];
        [_sectionsArray addObject:@"添加团队成员"];
    }
    return _sectionsArray;
}

- (NSMutableArray *)itemsArray
{
    if (!_itemsArray)
    {
        _itemsArray = [NSMutableArray arrayWithCapacity:0];
        
        
    }
    return _itemsArray;
}



- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = WCClear;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];   // 不能使用CGRectZero，不起作用
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    
    return _tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray[section] count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.frame = CGRectMake(0, 0, self.tableView.width, 60);
    headerView.backgroundColor = WCWhite;
    
    if (section == 0)
    {
        UILabel *titleLable = [WCUIKitControl createLabelWithFrame:CGRectMake(10, 10, 80, 40) Text:@"创建团队"];
        [headerView addSubview:titleLable];
        
        UITextField *textF = [WCUIKitControl createTextFieldWithFrame:CGRectMake(90, 10, self.tableView.width - 100, 40) Placeholder:@"不少于3个字" TextAlignment:0 TextColor:WCBlack FontSize:kAppMiddleFontSize SecureTextEntry:NO BorderStyle:UITextBorderStyleRoundedRect KeyboardType:UIKeyboardTypeDefault];
        [headerView addSubview:textF];
    }
    else
    {
        UILabel *addLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(10, 10, 120, 40) Text:@"添加团队成员"];
        [headerView addSubview:addLabel];
        
        UILabel *numLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(self.tableView.width - 80, 10, 60, 40) Text:nil];
        [headerView addSubview:numLabel];
    }
    
    return headerView;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UsrContactFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID"];
//    
//    if (!cell)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"UsrContactFriendCell" owner:nil options:nil] firstObject];
//    }
//    
//    if (self.dataArray
//        && self.dataArray.count)
//    {
//        M8FriendInfo *info = self.dataArray[indexPath.row];
//        [cell configWithFriendItem:info];
//    }
//    
//    return cell;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}





@end
