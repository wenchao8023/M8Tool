//
//  M8CallViewController+UI.h
//  M8Tool
//
//  Created by chao on 2017/7/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController.h"

@interface M8CallViewController (UI)<CallRenderDelegate, MeetHeaderDelegate, M8MeetDeviceViewDelegate, RecvChildVCDelegate>

- (void)onHiddeMenuView;

@end
