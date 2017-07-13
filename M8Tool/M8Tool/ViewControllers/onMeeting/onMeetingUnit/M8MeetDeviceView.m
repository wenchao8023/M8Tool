//
//  M8MeetDeviceView.m
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8MeetDeviceView.h"


@interface M8MeetDeviceView ()
{
    CGRect _myFrame;
}
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;    //分享
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;     //发言
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;   //中间的按钮
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;     //菜单
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;   //切换到浮动视图

@end


@implementation M8MeetDeviceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        _myFrame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = _myFrame;
}


- (void)setCenterBtnImg:(NSString *)imgStr
{
    [self.centerBtn setBackgroundImage:kGetImage(imgStr) forState:UIControlStateNormal];
}


/**
分享
*/
- (IBAction)onShareAction:(id)sender
{
    [self deviceActionInfoValue:@(kOnDeviceActionShare) key:kDeviceAction];
}

/**
 发言
 */
- (IBAction)onNoteAction:(id)sender
{
    [self deviceActionInfoValue:@(kOnDeviceActionNote) key:kDeviceAction];
}

/**
 私信、挂断
 */
- (IBAction)onCenterAction:(id)sender
{
    [self deviceActionInfoValue:@(kOnDeviceActionCenter) key:kDeviceAction];
    
}

/**
 菜单
 */
- (IBAction)onMenuAction:(id)sender
{
    [self deviceActionInfoValue:@(kOnDeviceActionMenu) key:kDeviceAction];
}

/**
 缩小
 */
- (IBAction)onSwichRenderAction:(id)sender
{
    [self deviceActionInfoValue:@(kOnDeviceActionSwichRender) key:kDeviceAction];
}

#pragma mark - MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key
{
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(M8MeetDeviceViewActionInfo:)])
    {
        [self.WCDelegate M8MeetDeviceViewActionInfo:actionInfo];
    }
}


@end
