//
//  SettingPasswordView.m
//  M8Tool
//
//  Created by chao on 2017/7/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "SettingPasswordView.h"




@interface SettingPasswordView ()
{
    CGRect _myFrame;
}

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UITextField *firstPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdTF;

@end


@implementation SettingPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.frame = _myFrame;
}


- (IBAction)okAction:(id)sender
{
    if (!self.firstPwdTF.text.length)
    {
        [AlertHelp alertWith:@"温馨提示" message:@"请输入密码" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return ;
    }
    else if (!self.secondPwdTF.text.length)
    {
        [AlertHelp alertWith:@"温馨提示" message:@"请再次输入密码确认" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return ;
    }
    else if (![self.firstPwdTF.text isEqualToString:self.secondPwdTF.text])
    {
        [AlertHelp alertWith:@"温馨提示" message:@"两次输入不一致，请确认后输入" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return ;
    }
    else if ([self.secondPwdTF.text isEqualToString:[M8UserDefault getLoginPwd]])
    {
        [AlertHelp alertWith:@"温馨提示" message:@"新密码不能与旧密码相同" cancelBtn:@"确定" alertStyle:UIAlertControllerStyleAlert cancelAction:nil];
        return ;
    }
    
    if ([self.firstPwdTF.text isEqualToString:self.secondPwdTF.text])
    {
        LoadView *loadView = [LoadView loadViewWith:@"修改密码"];
        [self addSubview:loadView];
        
        WCWeakSelf(self);
        ModifyPwdWithOldPwdRequest *modifyReq = [[ModifyPwdWithOldPwdRequest alloc] initWithHandler:^(BaseRequest *request) {
            
            [loadView removeFromSuperview];
            
            if (weakself.succHandle)
            {
                weakself.succHandle(weakself.secondPwdTF.text);
            }
            
        } failHandler:^(BaseRequest *request) {
            
        }];
        
        modifyReq.token = [AppDelegate sharedAppDelegate].token;
        modifyReq.uid   = [M8UserDefault getLoginId];
        modifyReq.oldpwd= [M8UserDefault getLoginPwd];
        modifyReq.pwd   = self.secondPwdTF.text;
        
        [[WebServiceEngine sharedEngine] AFAsynRequest:modifyReq];
    }
}

@end
