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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
