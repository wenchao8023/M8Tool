//
//  M8LiveDeviceView.m
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveDeviceView.h"




@interface M8LiveDeviceView ()
{
//    M8LiveDeviceType _liveDeviceType;
    CGRect _myFrame;
}
@property (weak, nonatomic) IBOutlet UIButton *leftButton1;

@property (weak, nonatomic) IBOutlet UIButton *leftButton2;

@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton1;

@property (weak, nonatomic) IBOutlet UIButton *rightButton2;



@end




@implementation M8LiveDeviceView

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

/**
 分享
 */
- (IBAction)onShareAction:(id)sender
{
    [self deviceActionInfoValue:@"onShareAction" key:kLiveDeviceAction];
}

/**
 发言
 */
- (IBAction)onNoteAction:(id)sender
{
    [self deviceActionInfoValue:@"onNoteAction" key:kLiveDeviceAction];
}

/**
 私信
 */
- (IBAction)onPrivateChatAction:(id)sender
{
    [self deviceActionInfoValue:@"onPrivateChatAction" key:kLiveDeviceAction];

}

/**
 菜单
 */
- (IBAction)onMenuAction:(id)sender
{
    [self deviceActionInfoValue:@"onMenuAction" key:kLiveDeviceAction];
}

/**
 缩小
 */
- (IBAction)onSwichRenderAction:(id)sender
{
    [self deviceActionInfoValue:@"onSwichRenderAction" key:kLiveDeviceAction];
}


#pragma mark - MeetDeviceActionInfo:
- (void)deviceActionInfoValue:(id)value key:(NSString *)key
{
    NSDictionary *actionInfo = @{key : value};
    if ([self.WCDelegate respondsToSelector:@selector(LiveDeviceViewActionInfo:)])
    {
        [self.WCDelegate LiveDeviceViewActionInfo:actionInfo];
    }
}



@end
