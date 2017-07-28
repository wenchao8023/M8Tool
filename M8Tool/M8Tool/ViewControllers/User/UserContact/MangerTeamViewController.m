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



@interface MangerTeamViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>



@end



@implementation MangerTeamViewController


#pragma mark - inits
- (instancetype)initWithType:(MangerTeamType)type isManager:(BOOL)isManager  contactType:(ContactType)contactType
{
    if (self = [super init])
    {
        self.teamType = type;
        self.isManger = isManager;
        self.contactType = contactType;
    }
    return self;
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
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = WCClear;
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];   // 不能使用CGRectZero，不起作用
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.01)];
        [self.contentView addSubview:(_tableView = tableView)];
    }
    
    return _tableView;
}

#pragma mark - view life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self onNetloadData];
    
    // 重新设置导航视图 >> 添加右侧按钮
    [self resetNavi];
    
    [self tableView];
    
    [self createButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
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





#pragma mark - UIKit
- (void)resetNavi
{
    if (self.teamType == MangerTeamType_Company &&
        self.isManger)
    {
        CGFloat btnWidth = 40;
        UIButton *addBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH - kContentOriginX - btnWidth,
                                                                            kDefaultStatuHeight,
                                                                            btnWidth,
                                                                            kDefaultCellHeight)
                                                          Target:self
                                                          Action:@selector(onDeleteCompanyAction)
                                                           Title:@"删除"];
        [addBtn setAttributedTitle:[CommonUtil customAttString:@"删除"
                                                      fontSize:kAppSmallFontSize
                                                     textColor:WCRed
                                                     charSpace:kAppKern_0]
                          forState:UIControlStateNormal];
        [self.headerView addSubview:addBtn];
    }
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
    
    
    //添加按钮标题 + 添加按钮是否可点击
    NSString *buttonStr = nil;
    BOOL buttonEnable = NO;
    
    switch (self.contactType)
    {
        case ContactType_sel:       //选人
        {
            buttonStr = @"选择";
        }
            break;
        case ContactType_tel:       //电话
        {
            buttonStr = @"添加";
        }
            break;
        case ContactType_contact:   //通讯录
        {
            buttonStr = @"添加";
            if (self.isManger)
            {
                if (self.teamType == MangerTeamType_Company)
                {
                    buttonStr = @"添加部门";
                }
                if (self.teamType == MangerTeamType_Partment)
                {
                    buttonStr = @"添加成员";
                }
                buttonEnable = YES;
            }
        }
            break;
        case ContactType_invite:    //邀请成员
        {
            buttonStr = @"邀请";
        }
            break;
        default:
            break;
    }

    
    // 添加按钮
    UIButton *addButton = [WCUIKitControl createButtonWithFrame:CGRectMake(self.contentView.width / 2,
                                                                             self.contentView.height - kDefaultCellHeight,
                                                                             self.contentView.width / 2,
                                                                             kDefaultCellHeight)
                                                           Target:self
                                                           Action:@selector(onAddAction)
                                                            Title:buttonStr];
    [addButton setAttributedTitle:[CommonUtil customAttString:addButton.titleLabel.text
                                                       fontSize:kAppMiddleFontSize
                                                      textColor:WCWhite
                                                      charSpace:kAppKern_2]
                           forState:UIControlStateNormal];
    addButton.enabled = buttonEnable;
    [addButton setTitleColor:WCGray forState:UIControlStateDisabled];
    [addButton setTitleColor:WCWhite forState:UIControlStateNormal];
    [addButton setBackgroundColor:WCButtonColor];
    [self.contentView addSubview:(self.addButton = addButton)];
    
    
}

#pragma mark - UITableViewDelegate
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
        
        if (section < self.sectionArray.count)
        {
            UILabel *partLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(10, 10, self.view.width - 100, 40) Text:self.sectionArray[section]];
            [headView addSubview:partLabel];
        }
        
        //隐藏分组内容
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderViewAction:)];
        [headView addGestureRecognizer:tap];
        
        if (self.isManger &&
            self.contactType == ContactType_contact)
        {
            // 添加成员按钮
            UIButton *addMemButton = [WCUIKitControl createButtonWithFrame:CGRectMake(self.tableView.width - 80, 10, 70, 40)
                                                                    Target:self
                                                                    Action:@selector(onAddMemberAction:)
                                                                     Title:@"+成员"
                                      ];
            addMemButton.titleLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
            [addMemButton setTitleColor:WCBlack forState:UIControlStateNormal];
            [addMemButton setBorder_left_color:WCLightGray width:1];
            [addMemButton setTag:210 + section];
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
        if (self.contactType == ContactType_sel ||
            self.contactType == ContactType_invite)
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            
            M8MemberInfo *info = self.itemArray[indexPath.section][indexPath.row];
            if ([modelManger isExistInviteArray:info.uid])
            {
                [friendCell configMemberitemUnableUnselect:info];
            }
            else if ([modelManger isExistSelectArray:info.uid])
            {
                [friendCell configMemberItem:info isSelected:YES];
            }
            else
            {
                [friendCell configMemberItem:info isSelected:NO];
            }
        }
        else
        {
            [friendCell configWithMemberItem:self.itemArray[indexPath.section][indexPath.row]];
        }
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



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    WCLog(@"didShowViewController : %@", [viewController class]);
    
    //选人之后退出界面需要清空 selectArray 中的数据，邀请的时候不需要
    if (self.contactType == ContactType_sel)
    {
        if ([NSStringFromClass([viewController class]) isEqualToString:@"UserContactViewController"])
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger removeSelectMembers];
        }
    }
    
    if (self.contactType == ContactType_invite)
    {
        if (_isInviteBack)
        {
            return ;
        }
        else
        {
            M8InviteModelManger *modelManger = [M8InviteModelManger shareInstance];
            [modelManger removeSelectMembers];
        }
    }
}


@end
