//
//  M8MeetBaseViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M8MeetHeaderView.h"
#import "M8MeetDeviceView.h"



/**
 会议界面
 
 添加头部 和 设备界面
 他们的代理需要在子类中对应自己的逻辑自行实现
 */
@interface M8MeetBaseViewController : UIViewController<MeetDeviceDelegate>

/**
 背景图片
 */
@property (nonatomic, strong, nullable) UIImageView *bgImageView;

@property (nonatomic, strong) M8MeetHeaderView * _Nonnull headerView;
@property (nonatomic, strong) M8MeetDeviceView * _Nonnull deviceView;

@end
