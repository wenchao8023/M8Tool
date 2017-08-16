//
//  CreateCompanyViewController.m
//  M8Tool
//
//  Created by chao on 2017/7/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "CreateCompanyViewController.h"

#import "UsrContactFriendCell.h"



@interface CreateCompanyViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSInteger _currentMembers;
    UIAlertAction *_saveAction;
    NSString *_companyName;
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
    
    UIButton *createTeamBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(kDefaultMargin,
                                                                              self.contentView.height - kDefaultMargin - kDefaultCellHeight,
                                                                              self.contentView.width - 2 * kDefaultMargin,
                                                                              kDefaultCellHeight)
                                                            Target:self
                                                            Action:@selector(onCreateTeamAction)
                                                             Title:@"创建团队"];
    [createTeamBtn setAttributedTitle:[CommonUtil customAttString:createTeamBtn.titleLabel.text
                                                        fontSize:kAppNaviFontSize
                                                       textColor:WCWhite
                                                       charSpace:kAppKern_2]
                            forState:UIControlStateNormal];
    WCViewBorder_Radius(createTeamBtn, kDefaultCellHeight / 2);
    [createTeamBtn setBackgroundColor:WCButtonColor];
    [self.contentView addSubview:createTeamBtn];
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
        
        [_itemsArray addObject:@[]];
        
        M8MemberInfo *info = [[M8MemberInfo alloc] init];
        info.uid  = [M8UserDefault getLoginId];
        info.nick = [M8UserDefault getLoginNick];
        [_itemsArray addObject:@[info]];
    }
    return _itemsArray;
}



- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
        tableView.height -= (kDefaultMargin * 2 + kDefaultCellHeight);
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
        
        UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, self.tableView.width - 100, 40)];
        textF.placeholder = @"不少于3个字";
        textF.clearButtonMode = UITextFieldViewModeWhileEditing;
        textF.delegate = self;
        [headerView addSubview:textF];
        
        if (_companyName.length >= 3)
        {
            textF.text = _companyName;
        }
    }
    else
    {
        UILabel *addLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(10, 10, 120, 40) Text:@"添加团队成员"];
        [headerView addSubview:addLabel];
        
        if (_currentMembers < 6)
        {
            UILabel *numLabel = [WCUIKitControl createLabelWithFrame:CGRectMake(self.tableView.width - 80, 10, 60, 40) Text:[NSString stringWithFormat:@"还差%ld人", (6 - _currentMembers)]];
            [headerView addSubview:numLabel];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddMemberAction)];
        [headerView addGestureRecognizer:tap];
    }
    
    return headerView;
}

- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsrContactFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UsrContactFriendCellID"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UsrContactFriendCell" owner:nil options:nil] firstObject];
    }
    
    [cell configWithMemberItem:self.itemsArray[indexPath.section][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!section)
    {
        return 10.f;
    }
    
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _companyName = textField.text;
}

/**
 创建公司
 1. 根据公司名创建公司
 2. 创建公司成功之后创建一个默认的部门 “组织架构”
 3. 将添加的成员加入 “组织架构” 部门
 */
- (void)onCreateTeamAction
{
    WCLog(@"创建团队");
    WCWeakSelf(self);
    CreateCompanyRequest *createTeamReq = [[CreateCompanyRequest alloc] initWithHandler:^(BaseRequest *request) {
        
        NSString *cid = ((CreateCompanyResponseData *)request.response.data).cid;
        [weakself createDefaultPart:cid];
        
    } failHandler:^(BaseRequest *request) {
        
        if (request.response.errorCode ==  10086)
        {
            [AlertHelp tipWith:@"团队已存在，请确认是否输入正确！" wait:1];
        }
    }];
    
    createTeamReq.token = [AppDelegate sharedAppDelegate].token;
    createTeamReq.uid   = [M8UserDefault getLoginId];
    createTeamReq.name  = _companyName;
    [[WebServiceEngine sharedEngine] AFAsynRequest:createTeamReq];
}

- (void)createDefaultPart:(NSString *)cid
{
    WCWeakSelf(self);
    int myCid = [cid intValue];
    CreatePartRequest *createPartReq = [[CreatePartRequest alloc] initWithHandler:^(BaseRequest *request) {
       
        NSString *did = ((CreatePartResponseData *)request.response.data).did;
        [weakself inviteMemberJoinPart:did];
        
    } failHandler:^(BaseRequest *request) {
        
    }];
    
    createPartReq.token = [AppDelegate sharedAppDelegate].token;
    createPartReq.uid   = [M8UserDefault getLoginId];
    createPartReq.cid   = myCid;
    createPartReq.name  = @"组织架构";
    [[WebServiceEngine sharedEngine] AFAsynRequest:createPartReq];
}


/**
 给用户发送邀请
 */
- (void)inviteMemberJoinPart:(NSString *)did
{
    NSMutableArray *memArr = [NSMutableArray arrayWithCapacity:0];
    for (M8MemberInfo *info in (NSArray *)self.itemsArray[1])
    {
        [memArr addObject:info.uid];
    }
    
    TIMFriendshipManager *manger = [TIMFriendshipManager sharedInstance];
    [manger AddFriendsToFriendGroup:did users:memArr succ:^(NSArray *friends) {
        
    } fail:^(int code, NSString *msg) {
        
    }];
}


- (void)onAddMemberAction
{
    [self.view endEditing:YES];
    
    if (_companyName.length < 3)
    {
        [AlertHelp tipWith:@"请输入正确的团队名" wait:1];
        return ;
    }
    
    AlertActionHandle contactHandle = ^(UIAlertAction *action){
        
        WCLog(@"从通讯录选择");
    };
    
    AlertActionHandle writeHandle = ^(UIAlertAction *action){
        
        WCLog(@"手动输入");
        [self onShowAddMemberAlert];
    };
    
    [AlertHelp alertWith:nil
                 message:nil
                 funBtns:@{@"从通讯录选择" : contactHandle, @"手动输入" : writeHandle}
               cancelBtn:@"取消"
          destructiveBtn:nil
              alertStyle:UIAlertControllerStyleActionSheet
            cancelAction:nil
        destrutiveAction:nil
     ];
}


- (void)onShowAddMemberAlert
{
    UIAlertController *addMemberAlert = [UIAlertController alertControllerWithTitle:@"添加成员" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    _saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTF  = addMemberAlert.textFields.firstObject;
        UITextField *phoneTF = addMemberAlert.textFields.lastObject;
        
        WCLog(@"name : %@\tphone : %@", nameTF.text, phoneTF.text);
        [self addMemberToItemArray:nameTF.text phone:phoneTF.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    _saveAction.enabled = NO;
    [addMemberAlert addAction:_saveAction];
    [addMemberAlert addAction:cancelAction];
    
    [addMemberAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    
        textField.placeholder = @"输入姓名";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [addMemberAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"输入手机号";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [self presentViewController:addMemberAlert animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *nameTF  = alertController.textFields.firstObject;
        UITextField *phoneTF = alertController.textFields.lastObject;
        _saveAction.enabled = YES;
//        _saveAction.enabled = (nameTF.text.length > 1 && [phoneTF.text validateMobile]);
    }
}

- (void)addMemberToItemArray:(NSString *)name phone:(NSString *)phone
{
    M8MemberInfo *info = [M8MemberInfo new];
    info.nick = name;
    info.uid  = phone;
    
    NSMutableArray *infoArr = [NSMutableArray arrayWithArray:self.itemsArray[1]];
    [infoArr addObject:info];
    [self.itemsArray replaceObjectAtIndex:1 withObject:infoArr];
    
    _currentMembers = infoArr.count;
    
    [self.tableView reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
