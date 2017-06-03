//
//  ModifyViewController.m
//  M8Tool
//
//  Created by chao on 2017/5/19.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ModifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.textField.text = self.originContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.contentView setHeight:kContentHeight_bottom30];
    
    CGRect frame = [self createUI];
    frame.origin.y = CGRectGetMaxY(frame) + 20;
    frame.origin.x = kDefaultMargin;
    frame.size.height = 40;
    frame.size.width = self.contentView.width - 2 * kDefaultMargin;
    UIButton *okButton = [WCUIKitControl createButtonWithFrame:frame Target:self Action:@selector(okAction) Title:@""];
    [okButton setAttributedTitle:[CommonUtil customAttString:@"确定" fontSize:kAppMiddleFontSize textColor:WCWhite charSpace:kAppKern_8] forState:UIControlStateNormal];
    WCViewBorder_Radius(okButton, 20);
    okButton.backgroundColor = WCButtonColor;
    [self.contentView addSubview:okButton];
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        textField.textColor = WCBlack;
        textField.backgroundColor = WCWhite;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.height = 40.f;
        [textField becomeFirstResponder];
        [self.contentView addSubview:(_textField = textField)];
    }
    return _textField;
}

- (CGRect)createUI {
    switch (self.modifyType) {
        case Modify_text:
        {
            return self.textField.frame;
        }
            break;
        case Modify_time:
        {
            return CGRectZero;
        }
            break;
        case Modify_date:
        {
            return CGRectZero;
        }
            break;
            
        default:
            return CGRectZero;
            break;
    }
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
