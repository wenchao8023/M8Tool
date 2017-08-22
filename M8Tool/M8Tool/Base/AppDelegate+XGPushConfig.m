//
//  AppDelegate+XGPushConfig.m
//  M8Tool
//
//  Created by chao on 2017/7/21.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate+XGPushConfig.h"
#import "AppCallKitManager.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif


@implementation AppDelegate (XGPushConfig)
/**
 *  注册远程推送
 *
 *  @param application UIApplication 实例
 *  @param deviceToken 设备唯一标识符
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
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


/**
 *  注册远程推送失败回调
 *
 *  @param application application description
 *  @param error       注册远程推送失败错误信息
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
}

//"Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications"



/**
 *  收到通知的回调(iOS10之后废弃)
 *
 *  @param application UIApplication 实例
 *  @param userInfo    推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    
}


/**
 *  收到静默推送的回调
 *
 *  @param application  UIApplication 实例
 *  @param userInfo 推送时指定的参数
 *  @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    
    
    //TODO...
    /**
     *  如果App的状态不是活跃的就发送通知，这里可以做本地通知，通知用户来电
     *  如果是活跃的就忽略，程序会自动打开通知界面
     *  这里不能直接使用 callManger (系统支持在iOS10以上)，后期迭代会做
     *  发起通话不能用静默通知实现
     */
    
    /**
     typedef enum UIApplicationState : NSInteger {
     UIApplicationStateActive,       前台
     UIApplicationStateInactive,     前后台过度状态
     UIApplicationStateBackground    后台
     } UIApplicationState;
     */
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    
    
    //TODO...   handle notification with type
    
    NSDictionary *xgInfoDic = response.notification.request.content.userInfo;
    
    M8RemoteNotificationType notifyType;
    [[xgInfoDic objectForKey:@"notifyType"] getValue:&notifyType];
    
    switch (notifyType)
    {
        case M8RemoteNotificationType_MAKECALL:
        {
            
        }
            break;
            
        default:
            break;
    }
}


// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSDictionary *xgInfoDic = notification.request.content.userInfo;
    
    M8RemoteNotificationType notifyType;
    [[xgInfoDic objectForKey:@"notifyType"] getValue:&notifyType];
    
    switch (notifyType)
    {
        case M8RemoteNotificationType_MAKECALL:
        {
            completionHandler(UNNotificationPresentationOptionSound);
        }
            break;
            
        default:
            break;
    }
    
    /**
     *  这个 completionHandle 是回传给 App 的参数
     *
     *  @param UNNotificationPresentationOptionAlert 传了哪个就表示哪儿生效
     *
     *  @return return value
     */
    
    /**
     *  如果是在前台的时候收到通话邀请，则只需要有声音即可
     */
    //    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif



#pragma mark - -- 发送本地通知
- (void)sendLocalNotify:(NSString *)alertBody
{
    UILocalNotification *localNotify = [[UILocalNotification alloc] init];
    localNotify.fireDate             = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotify.alertBody            = alertBody;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotify];
}






#pragma mark - -- 注册通知
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
