//
//  AppDelegate.h
//  M8Tool
//
//  Created by chao on 2017/3/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <PushKit/PushKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, nullable) UIWindow *window;

@property (nonatomic, copy, nullable) NSString *token;

@property (nonatomic, strong, nullable) NSData *deviceToken;

@property (nonatomic, copy, nullable) NSString *deviceTokenStr;

@property (nonatomic, assign) BOOL netEnable;//判断网络是否可用


@property (nonatomic, readonly, strong, nullable) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

