//
//  M8MutiLoginViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/29.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MutiLoginViewController.h"
#import "M8LoginWebService.h"

@interface M8MutiLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *experButton;



@end

@implementation M8MutiLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[UINavigationBar appearance] setBarTintColor:WCClear];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WCWhite,
                                                           NSFontAttributeName:[UIFont systemFontOfSize:kAppNaviFontSize]
                                                           }];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    WCViewBorder_Radius_Width_Color(_loginButton, 30, 2, WCWhite);
    WCViewBorder_Radius_Width_Color(_registButton, 30, 2, WCWhite);
    
    _registButton.backgroundColor = WCWhite;
    [_registButton setTitleColor:WCRGBColor(0x6e / 255.0, 0x6e / 255.0, 0x70 / 255.0) forState:UIControlStateNormal];
    
    
//    _loginButton.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
//    _registButton.adjustsImageWhenHighlighted = NO;
//    
//    [_loginButton setBackgroundImage:[UIImage imageWithColor:WCWhite] forState:UIControlStateHighlighted];
//    [_loginButton setTitleColor:WCLightGray forState:UIControlStateHighlighted];
//
//    [_registButton setBackgroundImage:[UIImage imageWithColor:WCWhite] forState:UIControlStateHighlighted];
//    [_registButton setTitleColor:WCLightGray forState:UIControlStateHighlighted];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



/**
 体验

 @param sender sender
 */
- (IBAction)onExperAction:(id)sender
{
    WCLog(@"onExperAction");
}


/**
 微信登录
 
 @param sender sender
 */
- (IBAction)onWechatAction:(id)sender
{
    WCLog(@"onWechatAction");
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess)
        {
            WCLog(@"success!");
        }
        else
        {
            WCLog(@"wrong");
        }
    }];
}


/**
 企业微信登录
 
 @param sender sender
 */
- (IBAction)onCWechatAction:(id)sender
{
    WCLog(@"onCWechatAction");
}


/**
 QQ登录
 
 @param sender sender
 */
- (IBAction)onQQAction:(id)sender
{
    WCLog(@"onQQAction");
    
    __block NSString *openid = nil;
    __block NSString *nick = nil;
    
    // 拉取授权前，先取消上一次授权，否则不会跳转第三方————》没用☹
    [ShareSDK cancelAuthorize:SSDKPlatformTypeAny];
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             openid = user.uid;
             nick = user.nickname;
//             NSLog(@"uid=%@",user.uid);
//             NSLog(@"%@",user.credential);
//             NSLog(@"token=%@",user.credential.token);
//             NSLog(@"nickname=%@",user.nickname);
             
             LoadView *loginWaitView = [LoadView loadViewWith:@"正在登录"];
             [self.view addSubview:loginWaitView];
             
             M8LoginWebService *webService = [[M8LoginWebService alloc] init];
             [webService M8QQLoginWithOpenId:openid nick:nick cancelPVN:^{
                 
                 [loginWaitView removeFromSuperview];
             }];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
     }];
    
    
    

}


@end
