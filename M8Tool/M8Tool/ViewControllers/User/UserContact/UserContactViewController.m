//
//  UserContactViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/22.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserContactViewController.h"
#import "UsrContactView.h"


@interface UserContactViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UsrContactView *contactView;

@end

@implementation UserContactViewController
@synthesize _searchView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [WCNotificationCenter addObserver:self selector:@selector(shouldReloadFirstItemData) name:kNewFriendStatu_Notification object:nil];
}

- (void)shouldReloadFirstItemData
{
    [self.contactView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)createUI
{
    // 重新设置导航视图 >> 添加右侧按钮
    [self resetNavi];
    
    // 添加 搜索视图
    [self addSearchView];
    
    // 重新设置内容视图 >> 添加 tableView
    [self resetContentView];
}

- (void)resetNavi
{
    CGFloat btnWidth = 40;
    UIButton *addBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH - kContentOriginX - btnWidth,
                                                                        kDefaultStatuHeight,
                                                                        btnWidth,
                                                                        kDefaultCellHeight)
                                                      Target:self
                                                      Action:@selector(addAction)
                                                       Title:@"添加"];
    [addBtn setAttributedTitle:[CommonUtil customAttString:@"添加"
                                                  fontSize:kAppMiddleFontSize
                                                 textColor:WCWhite
                                                 charSpace:kAppKern_0]
                      forState:UIControlStateNormal];
    [self.headerView addSubview:addBtn];
}


- (void)addSearchView
{
    CGRect frame = self.contentView.frame;
    frame.size.height = kSearchView_height;
    BaseSearchView *searchView = [[BaseSearchView alloc] initWithFrame:frame target:self];
    WCViewBorder_Radius(searchView, kSearchView_height / 2);
    searchView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:(_searchView = searchView)];
}

- (void)resetContentView
{
    CGFloat originY = CGRectGetMaxY(_searchView.frame) + kMarginView_top;
    self.contentView.y = originY;
    self.contentView.height = self.contentView.height - originY + kDefaultNaviHeight;
    
    UsrContactView *contactView = [[UsrContactView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped contactType:self.contactType];
    [self.contentView addSubview:(_contactView = contactView)];
}


#pragma mark -- actions
- (void)addAction
{
    WCLog(@"add more contact");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *addFrientdAction = [UIAlertAction actionWithTitle:@"添加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self onAddFriendAction];
    }];
    
    UIAlertAction *addTeamAction = [UIAlertAction actionWithTitle:@"添加团队" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.contactView onSubviewAddAction];
    }];
    
    [alert addAction:addFrientdAction];
    [alert addAction:addTeamAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onAddFriendAction
{
    UIAlertController *createTeamAlert = [UIAlertController alertControllerWithTitle:@"添加好友" message:@"确认即发送邀请" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTF  = createTeamAlert.textFields.firstObject;
        
//        if ([nameTF.text validateMobile])
//        {
//            [AlertHelp tipWith:@"请输入正确的手机号" wait:1];
//            
//            return ;
//        }
        
        NSMutableArray * users = [[NSMutableArray alloc] init];
        
        TIMAddFriendRequest* req = [[TIMAddFriendRequest alloc] init];
        
        // 添加好友
        req.identifier = nameTF.text;
        // 添加备注 002Remark
//        req.remark = [NSString stringWithFormat:@"我是 %@", [M8UserDefault getLoginNick]];
        // 添加理由
//        req.addWording = [NSString stringWithFormat:@"我是 %@", [M8UserDefault getLoginId]];
        
        [users addObject:req];
        
        [[TIMFriendshipManager sharedInstance] AddFriend:users succ:^(NSArray *friends) {
            
            for (TIMFriendResult * res in friends)
            {
                if (res.status != TIM_FRIEND_STATUS_SUCC)
                {
                    NSLog(@"AddFriend failed: user=%@ status=%ld", res.identifier, (long)res.status);
                }
                else
                {
                    NSLog(@"AddFriend succ: user=%@ status=%ld", res.identifier, (long)res.status);
                }
            }
            
        } fail:^(int code, NSString *msg) {
            
            NSLog(@"add friend fail: code=%d err=%@", code, msg);
            if (code == 6011)
            {
                [AlertHelp tipWith:@"用户不存在" wait:1];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [createTeamAlert addAction:saveAction];
    [createTeamAlert addAction:cancelAction];
    
    [createTeamAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"好友手机号";
    }];
    
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:createTeamAlert animated:YES completion:nil];
}



#pragma mark -- 判断视图类型
- (NSString *)getTitle
{
    switch (self.contactType)
    {
        case ContactType_tel:
            return @"手机通话";
            break;
        case ContactType_contact:
            return @"通讯录";
            break;
        case ContactType_sel:
            return @"选择参会人员";
            break;
        case ContactType_invite:
            return @"邀请成员参会";
            break;
        default:
            return @"通讯录";
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [WCNotificationCenter removeObserver:self name:kNewFriendStatu_Notification object:nil];
}
@end
