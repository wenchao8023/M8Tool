//
//  UsrView.
//  M8Tool
//
//  Created by chao on 2017/5/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrView.h"
//#import "UserCardViewController.h"

@interface UsrView ()



/**
 tag: 301, 302, 303, 304, 305
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;


@end

@implementation UsrView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.frame = frame;
        
        [self setAttText];
    }
    
    return self;
}

- (void)setAttText {
    for (int i = 1; i <= 5; i++) {
        UILabel *label = [self viewWithTag:300+i];
        [label setAttributedText:[CommonUtil customAttString:label.text
                                                    fontSize:kAppNaviFontSize
                                                   textColor:WCBlack
                                                   charSpace:kAppKern_4]
         ];
    }
}




- (IBAction)cardAction:(id)sender {
    WCLog(@"我的名片");
    [self pushToViewController:@"UserCardViewController"];
//    UserCardViewController *vc = [[UserCardViewController alloc] init];
//    vc.isExitLeftItem = YES;
//    [[[AppDelegate sharedAppDelegate] navigationViewController] pushViewController:vc animated:YES];
}

- (IBAction)walletAction:(id)sender {
    WCLog(@"我的钱包");
}

- (IBAction)companyAction:(id)sender {
    WCLog(@"我的企业");
}

- (IBAction)settingAction:(id)sender {
    WCLog(@"设置");
    [self pushToViewController:@"UserSettingViewController"];
}

- (void)pushToViewController:(NSString *)viewControllerName {
    Class myClass = NSClassFromString(viewControllerName);
    BaseViewController *vc = [myClass new];
    vc.isExitLeftItem = YES;
    [[[AppDelegate sharedAppDelegate] navigationViewController] pushViewController:vc animated:YES];
}
@end
