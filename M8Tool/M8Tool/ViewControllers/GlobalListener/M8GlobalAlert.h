//
//  M8GlobalAlert.h
//  M8Tool
//
//  Created by chao on 2017/7/31.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  全局提示代理
 */
@protocol GlobalAlertDelegate <NSObject>

@optional
- (void)onGlobalAlertLeftButtonAction;
- (void)onGlobalAlertRightButtonAction;

@end



@interface M8GlobalAlert : UIView

@property (nonatomic, weak) id<GlobalAlertDelegate> _Nullable WCDelegate;

- (instancetype _Nullable)initWithFrame:(CGRect)frame alertInfo:(NSString *_Nullable)alertInfo alertType:(GlobalAlertType)alertType;

@end
