//
//  AppDelegate+ControlViewController.h
//  M8Tool
//
//  Created by chao on 2017/5/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (ControlViewController)



@property (nonatomic, copy) NSString *token;
+ (instancetype)sharedAppDelegate;
+ (UIAlertController *)showAlertWithTitle:(NSString *)title message:(NSString *)msg okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle ok:(ActionHandle)succ cancel:(ActionHandle)fail;
+ (UIAlertController *)showAlert:(UIViewController *)rootVC title:(NSString *)title message:(NSString *)msg okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle ok:(ActionHandle)succ cancel:(ActionHandle)fail;
- (UINavigationController *)navigationViewController;
- (UIViewController *)topViewController;
- (NSArray *)popToRootViewController;
- (UIViewController *)popViewController;
- (NSArray *)popToViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
