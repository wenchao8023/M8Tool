//
//  ModifyViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ModifyViewController.h"


typedef void(^SaveBlock)();

@interface NaviBarView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, copy)   SaveBlock saveBlock;

@end


@implementation NaviBarView

- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kDefaultNaviHeight);
        self.backgroundColor = WCClear;
        
        // 返回视图
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(kMarginView_horizontal, kDefaultStatuHeight, 60, kDefaultCellHeight);
        
        UIImageView *imageV = [WCUIKitControl createImageViewWithFrame:CGRectMake(0, 0, 20, kDefaultCellHeight) ImageName:@""];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, kDefaultCellHeight)];
        label.userInteractionEnabled = YES;
        label.attributedText = [CommonUtil customAttString:@"返回"
                                                  fontSize:kAppMiddleFontSize
                                                 textColor:WCWhite
                                                 charSpace:kAppKern_4
                                                  fontName:kFontNameDroidSansFallback];
        [backView addSubview:imageV];
        [backView addSubview:label];
        UITapGestureRecognizer *backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
        [backView addGestureRecognizer:backClick];
        [self addSubview:backView];
        
        // 标题
        CGFloat titleX = CGRectGetMaxX(backView.frame) + kMarginView_top;
        CGFloat titleW = SCREEN_WIDTH - 2 * titleX;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, kDefaultStatuHeight, titleW, kDefaultCellHeight)];
        titleLabel.textAlignment = 1;
        [self addSubview:(_titleLabel = titleLabel)];
        
        // 右侧保存按钮
        UIButton *saveButton = [WCUIKitControl createButtonWithFrame:CGRectMake(self.width - 60 - kMarginView_horizontal,
                                                                                27,
                                                                                60,
                                                                                30)
                                                              Target:self
                                                              Action:@selector(saveAction)
                                                               Title:@"保存"];
        saveButton.enabled = NO;
        WCViewBorder_Radius(saveButton, 2);
        
        saveButton.backgroundColor = [UIColor colorWithRed:0.04 green:0.43 blue:0.4 alpha:0.6];
        [saveButton setAttributedTitle:[CommonUtil customAttString:@"保存"
                                                           fontSize:kAppMiddleFontSize
                                                          textColor:WCLightGray
                                                          charSpace:kAppKern_4]
                               forState:UIControlStateNormal];

        
        [self addSubview:(_saveButton = saveButton)];
    }
    return self;
}

- (void)setSaveButtonIsEnable:(BOOL)enable {
    _saveButton.enabled = enable;
    if (enable) {
        _saveButton.backgroundColor = WCButtonColor;
        [_saveButton setAttributedTitle:[CommonUtil customAttString:@"保存"
                                                          fontSize:kAppMiddleFontSize
                                                         textColor:WCWhite
                                                         charSpace:kAppKern_4]
                              forState:UIControlStateNormal];
        
    }
    else {
        _saveButton.backgroundColor = [UIColor colorWithRed:0.04 green:0.43 blue:0.4 alpha:0.6];
        [_saveButton setAttributedTitle:[CommonUtil customAttString:@"保存"
                                                           fontSize:kAppMiddleFontSize
                                                          textColor:WCLightGray
                                                          charSpace:kAppKern_4]
                               forState:UIControlStateNormal];
        
    }
}

- (void)backAction{
    [[AppDelegate sharedAppDelegate] popViewController];
}

- (void)saveAction {
    WCLog(@"保存");
    self.saveBlock();
}

- (void)setCustomTitle:(NSString *)titleStr {
    [_titleLabel setAttributedText:[CommonUtil customAttString:titleStr
                                                      fontSize:kAppNaviFontSize
                                                     textColor:WCWhite
                                                     charSpace:kAppKern_2]];
}




@end



@interface ModifyViewController ()

@property (nonatomic, strong) NaviBarView *naviBarView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ModifyViewController

- (NaviBarView *)naviBarView {
    if (!_naviBarView) {
        NaviBarView *naviBarView = [[NaviBarView alloc] init];
        [self.view addSubview:(_naviBarView = naviBarView)];
    }
    return _naviBarView;
}


- (UITextField *)textField {
    if (!_textField) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.naviBarView.frame) + kDefaultMargin, SCREEN_WIDTH, kDefaultCellHeight)];
        textField.textColor = WCBlack;
        textField.backgroundColor = WCBgColor;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [textField becomeFirstResponder];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:textField];
        
        [self.view addSubview:(_textField = textField)];
        
        
    }
    return _textField;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.textField.text = self.originContent;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 背景图片
    UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:kAppBgImageStr];
    [self.view addSubview:bgImageV];
    
    // 导航视图
    WCWeakSelf(self);
    self.naviBarView.saveBlock = ^(){
        [weakself okAction];
    };
    [self.naviBarView setCustomTitle:self.naviTitle];
    
    [self createUI];

}

- (void)createUI {
    
    switch (self.modifyType) {
        case Modify_text:
        {
            [self createTextView];
        }
            break;
        case Modify_time:
        {
            [self createTimeView];
        }
            break;
        case Modify_date:
        {
            [self createDateView];
        }
            break;
            
        default:
            [AppDelegate showAlertWithTitle:nil
                                    message:@"出错啦！"
                                    okTitle:@"确定"
                                cancelTitle:nil
                                         ok:^(UIAlertAction * _Nonnull action)
            {
                [[AppDelegate sharedAppDelegate] popViewController];
            }
                                     cancel:nil];
            break;
    }

    
    
}

- (void)createTextView {
    
    [self textField];
}

- (void)createTimeView {
    
}

- (void)createDateView {
    
}

#pragma mark - UITextFieldNotification
- (void)textFieldEditChanged:(NSNotification *)notify {
    UITextField *textField = (UITextField *)notify.object;
    [self.naviBarView setSaveButtonIsEnable:![textField.text isEqualToString:self.originContent]];
}



- (void)okAction {
    
    NSDictionary *modifyInfo;
    
    switch (self.modifyType) {
        case Modify_text:
        {
            modifyInfo = @{@"text" : self.textField.text};
        }
            break;
        case Modify_time:
        {
            
        }
            break;
        case Modify_date:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    if ([self.WCDelegate respondsToSelector:@selector(modifyViewMofifyInfo:)]) {
        [self.WCDelegate modifyViewMofifyInfo:modifyInfo];
    }
    
    if ([self.WCDelegate respondsToSelector:@selector(modifyViewMofifyInfo:indexPath:)]) {
        [self.WCDelegate modifyViewMofifyInfo:modifyInfo indexPath:self.indexPath];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
