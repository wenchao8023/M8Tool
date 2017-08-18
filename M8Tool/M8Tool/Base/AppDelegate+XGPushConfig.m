//
//  AppDelegate+XGPushConfig.m
//  M8Tool
//
//  Created by chao on 2017/7/21.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate+XGPushConfig.h"


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif


@implementation AppDelegate (XGPushConfig)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken
    //                                              account:[M8UserDefault getLoginId]
    //                                      successCallback:^{
    //
    //                                          NSLog(@"[XGDemo] register push success");
    //                                      }
    //                                        errorCallback:^{
    //
    //                                            NSLog(@"[XGDemo] register push error");
    //                                        }];
    
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken
                                      successCallback:^{
                                          
                                          NSLog(@"[XGDemo] register push success");
                                      }
                                        errorCallback:^{
                                            
                                            NSLog(@"[XGDemo] register push error");
                                        }];
    
    self.deviceToken    = deviceToken;
    self.deviceTokenStr = deviceTokenStr;
    NSLog(@"[XGDemo] device token is %@", deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
}


/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"[XGDemo] receive Notification");
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"[XGDemo] click notification");
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    completionHandler();
}


// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10)
    {
        // iOS 10
        [self registerPush10];
    }
    else if (sysVer >= 8)
    {
        // iOS 8-9
        [self registerPush8to9];
    }
    else {
        // before iOS 8
        [self registerPushBefore8];
    }
#else
    if (sysVer < 8)
    {
        // before iOS 8
        [self registerPushBefore8];
    }
    else
    {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate                  = self;
    
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9
{
    UIUserNotificationType types           = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerPushBefore8
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


@end
