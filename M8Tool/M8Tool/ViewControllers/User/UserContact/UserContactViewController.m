//
//  UserContactViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/22.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UserContactViewController.h"
#import "UsrContactView.h"




static const CGFloat kSearchView_height = 40.f;



#pragma mark 
#pragma mark -- 顶部搜索栏
/**
 顶部搜索栏
 */
@interface SearchView : UITextField<UITextFieldDelegate>



@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.placeholder = @"搜索";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.leftView = [WCUIKitControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40)
                                                        ImageName:nil
                                                          BgColor:WCGreen];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}


@end




#pragma mark
#pragma mark -- 主视图
@interface UserContactViewController ()

@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UsrContactView *contactView;

@end

@implementation UserContactViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHeaderTitle:[self getTitle]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    // 重新设置导航视图 >> 添加右侧按钮
    [self resetNavi];
    
    // 添加 搜索视图
    [self addSearchView];
    
    // 重新设置内容视图 >> 添加 tableView
    [self resetContentView];
}

- (void)resetNavi {
    static const CGFloat btnWidth = 40;
    UIButton *addBtn = [WCUIKitControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH - kMarginView_horizontal- btnWidth,
                                                                        kDefaultStatuHeight,
                                                                        btnWidth,
                                                                        kDefaultCellHeight)
                                                      Target:self
                                                      Action:@selector(addAction)
                                                       Title:@"添加"];
    [self.headerView addSubview:addBtn];
}

- (void)addSearchView {
    CGRect frame = self.contentView.frame;
    frame.size.height = kSearchView_height;
    SearchView *searchView = [[SearchView alloc] initWithFrame:frame];
    WCViewBorder_Radius(searchView, 2);
    searchView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:(_searchView = searchView)];
}

- (void)resetContentView {
    CGFloat originY = CGRectGetMaxY(_searchView.frame) + kMarginView_top;
    self.contentView.y = originY;
    self.contentView.height = kContentHeight_bottom30 - originY + kDefaultNaviHeight;
    
    UsrContactView *contactView = [[UsrContactView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    [self.contentView addSubview:(_contactView = contactView)];
}


#pragma mark -- actions
- (void)addAction {
    WCLog(@"add more contact");
}

#pragma mark -- 判断视图类型
- (NSString *)getTitle {
    switch (self.contactType) {
        case ContactType_tel:
            return @"手机通话";
            break;
        case ContactType_contact:
            return @"通讯录";
            break;
        case ContactType_sel:
            return @"选择参会人员";
            break;
        default:
            return @"通讯录";
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
