//
//  M8LiveInfoView.h
//  M8Tool
//
//  Created by chao on 2017/6/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M8LiveHeaderView.h"
#import "M8LiveNoteView.h"
#import "M8LiveDeviceView.h"

@interface M8LiveInfoView : UIView<ILVLiveIMListener, LiveDeviceViewDelegate>

@property (nonatomic, strong) NSString *host;

- (void)addTextToView:(id)newText;

@end
