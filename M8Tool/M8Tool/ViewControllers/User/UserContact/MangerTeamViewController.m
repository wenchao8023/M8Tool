//
//  MangerTeamViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController.h"
#import "UsrContactFriendCell.h"
#import "MangerTeamViewController+UI.h"
#import "MangerTeamViewController+Net.h"



static CGFloat kItemHeight = 60.f;



@interface MangerTeamViewController ()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation MangerTeamViewController


- (instancetype)initWithType:(MangerTeamType)type isManager:(BOOL)isManager
{
    if (self = [super init])
    {
        self.teamType = type;
        self.isManger = isManager;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onNetloadData];
    
    [self tableView];
    
    [self createButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.teamType == MangerTeamType_Company)
    {
        [self setHeaderTitle:self.cInfo.cname];
    }
    else if (self.teamType == MangerTeamType_Partment)
    {
        [self setHeaderTitle:self.dInfo.dname];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)sectionArray
{
    if (!_sectionArray)
    {
        _sectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _sectionArray;
}

- (NSMutableArray *)itemArray
{
    if (!_itemArray)
    {
        _itemArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect frame = self.contentView.bounds;
        frame.size.height -= (kDefaultMargin + kDefaultCellHeight);     // 减去 底部按钮所占的高度
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        tableView.height -= (kDefaultMargin + kDefaultCellHeight);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = WCClear;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];   // 不能使用CGRectZero，不起作用
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    
    return _tableView;
}

- (void)createButtons
{
    // 分享按钮
    UIButton *shareButton = [WCUIKitControl createButtonWithFrame:CGRectMake(0,
                                                                              self.contentView.height - kDefaultCellHeight,
                                                                              self.contentView.width / 2,
                                                                              kDefaultCellHeight)
                                                            Target:self
                                                            Action:@selector(onShareAction)
                                                             Title:@"分享"];
    [shareButton setAttributedTitle:[CommonUtil customAttString:shareButton.titleLabel.text
                                                       fontSize:kAppMiddleFontSize
                                                      textColor:WCWhite
                                                      charSpace:kAppKern_2]
                            forState:UIControlStateNormal];
    [shareButton setBorder_right_color:WCWhite width:1];
    [shareButton setBackgroundColor:WCButtonColor];
    [self.contentView addSubview:(self.shareButton = shareButton)];
    
    // 添加按钮
    UIButton *addButton = [WCUIKitControl createButtonWithFrame:CGRectMake(self.contentView.width / 2,
                                                                             self.contentView.height - kDefaultCellHeight,
                                                                             self.contentView.width / 2,
                                                                             kDefaultCellHeight)
                                                           Target:self
                                                           Action:@selector(onAddAction)
                                                            Title:@"添加"];
    [addButton setAttributedTitle:[CommonUtil customAttString:addButton.titleLabel.text
                                                       fontSize:kAppMiddleFontSize
                                                      textColor:WCWhite
                                                      charSpace:kAppKern_2]
                           forState:UIControlStateNormal];
    [addButton setBackgroundColor:WCButtonColor];
    [self.contentView addSubview:(self.addButton = addButton)];
    
    if (!self.isManger ||
        self.contactType == ContactType_tel)
    {
        self.addButton.enabled = NO;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.teamType == MangerTeamType_Company)
    {
        return self.sectionArray.count;
    }
    else
    {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.itemArray.count)
    {
        return [self.itemArray[section] count];
    }
    return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.teamType == MangerTeamType_Company)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kItemHeight)];
        headView.tag = 110 + section;
        [headView setBackgroundColor:WCWhite];
        
        if (self.sectionArray.count)
        {
            UILabel *partLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(10, 10, self.view.width - 100, 40) Text:self.sectionArray[section]];
            [headView addSubview:partLabel];
        }
        
        //隐藏分组内容
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderViewAction:)];
        [headView addGestureRecognizer:tap];
        
        if (self.isManger)
        {
            // 添加成员按钮
            UIButton *addMemButton = [WCUIKitControl createButtonWithFrame:CGRectMake(self.tableView.width - 80, 10, 70, 40)
                                                                 Target:self
                                                                 Action:@selector(onAddMemberAction)
                                                                  Title:@"添加成员"
                                   ];
            addMemButton.titleLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
            [addMemButton setTitleColor:WCBlack forState:UIControlStateNormal];
            [addMemButton setBorder_left_color:WCLightGray width:1];
            [headView addSubview:addMemButton];
        }
        
        return headView;
    }
    else
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsrContactFriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID"];
    
    if (!friendCell)
    {
        friendCell = [[[NSBundle mainBundle] loadNibNamed:@"UsrContactFriendCell" owner:nil options:nil] firstObject];
    }
    
    if (indexPath.section   < self.itemArray.count &&
        indexPath.row       < [self.itemArray[indexPath.section] count])
    {
        [friendCell configWithMemberItem:self.itemArray[indexPath.section][indexPath.row]];
    }
    
    return friendCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.teamType == MangerTeamType_Company)
    {
        return kItemHeight;
    }
    else
    {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.sectionArray.count)
    {
        return 0.01;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onDidSelectAtIndex:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
