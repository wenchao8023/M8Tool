//
//  M8RecvChildViewController.m
//  M8Tool
//
//  Created by chao on 2017/6/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8RecvChildViewController.h"

@interface M8RecvChildViewController ()

@property (weak, nonatomic) IBOutlet M8LiveLabel *sponsorLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *infoLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *inviteLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *rejectLabel;

@property (weak, nonatomic) IBOutlet M8LiveLabel *receiveLabel;


/**
 背景图片
 */
@property (nonatomic, strong, nullable) UIImageView *bgImageView;

@end

@implementation M8RecvChildViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (IBAction)onRejectAction:(id)sender {
    [self respondsToDelegate:@"reject"];
}

- (IBAction)onReceiveAction:(id)sender {
    [self respondsToDelegate:@"receive"];
}

- (void)respondsToDelegate:(NSString *)actionStr {
    if ([self.WCDelegate respondsToSelector:@selector(RecvChildVCAction:)]) {
        [self.WCDelegate RecvChildVCAction:actionStr];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bgImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:self.bgImageView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.sponsorLabel configLiveRenderText];
    [self.infoLabel configLiveText];
    [self.inviteLabel configLiveRenderText];
    [self.rejectLabel configLiveText];
    [self.receiveLabel configLiveText];
    
    self.sponsorLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
    self.infoLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
    self.inviteLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
    
    self.rejectLabel.font = [UIFont systemFontOfSize:kAppSmallFontSize];
    self.receiveLabel.font = [UIFont systemFontOfSize:kAppSmallFontSize];
    
    [self bgImageView];
    
    [WCNotificationCenter addObserver:self selector:@selector(themeSwichAction) name:kThemeSwich_Notification object:nil];
    
    NSString *inviteInfo;
    if (_invitation.callType == TILCALL_TYPE_VIDEO) {
        inviteInfo = [NSString stringWithFormat:@"%@邀请你视频通话", _invitation.sponsorId];
    }
    else if (_invitation.callType == TILCALL_TYPE_AUDIO) {
        inviteInfo = [NSString stringWithFormat:@"%@邀请你音频通话", _invitation.sponsorId];
    }
    self.infoLabel.text = inviteInfo;
    
    self.sponsorLabel.text = _invitation.sponsorId;
    self.inviteLabel.text  = [[ILiveLoginManager getInstance] getLoginId];
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
        UIImageView *bgImageV = [WCUIKitControl createImageViewWithFrame:self.view.bounds ImageName:imgStr ? imgStr : kDefaultThemeImage];
        [self.view addSubview:(_bgImageView = bgImageV)];
    }
    return _bgImageView;
}

- (void)themeSwichAction {
    NSString *imgStr = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeImage];
    [self.bgImageView setImage:[UIImage imageNamed:imgStr]];
}

- (void)dealloc {
    
    [WCNotificationCenter removeObserver:self name:kThemeSwich_Notification object:nil];
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
