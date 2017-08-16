//
//  M8RecvChildViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/15.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RecvChildVCDelegate <NSObject>

- (void)RecvChildVCAction:(NSString * _Nonnull)actionStr;

@end


@interface M8RecvChildViewController : UIViewController

@property (strong, nonatomic, nonnull) TILCallInvitation *invitation;

@property (nonatomic, weak) id _Nullable WCDelegate;

@end
