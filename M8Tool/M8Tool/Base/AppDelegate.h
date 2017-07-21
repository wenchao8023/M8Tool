//
//  AppDelegate.h
//  M8Tool
//
//  Created by chao on 2017/3/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>




@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) NSString *token;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

