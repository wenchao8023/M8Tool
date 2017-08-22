//
//  AppDelegate.m
//  M8Tool
//
//  Created by chao on 2017/3/27.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+XGPushConfig.h"
#import "AppDelegate+PushKit.h"
#import "APPLaunchViewController.h"




@interface AppDelegate ()

@end




@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
    [self loadShareSDK];
    
    [self loadILiveSDK];
    
    [self loadXGSDK:launchOptions];
    
    [self loadIFlySDK];
    
    self.netEnable = YES;
    
    [M8UserDefault setMeetingStatu:NO];
    
    [M8UserDefault setAppLaunching:YES];
    
    
    self.window                 = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = WCWhite;
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[APPLaunchViewController alloc] init];
    
    
    
    return YES;
}


#pragma mark - load sdks
-(void)loadShareSDK
{
    //注册ShareSDK
    [ShareSDK registerActivePlatforms:@[ @(SSDKPlatformTypeWechat),
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformTypeSMS),
                                         @(SSDKPlatformTypeDingTalk)] onImport:^(SSDKPlatformType platformType) {
                                             switch (platformType) {
                                                 case SSDKPlatformTypeWechat:
                                                     [ShareSDKConnector connectWeChat:[WXApi class]];
                                                     break;
                                                 case SSDKPlatformTypeQQ:
                                                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                     break;
                                                     //                                                     case SSDKPlatformTypeDingTalk:
                                                     //                                                     [ShareSDKConnector connectDingTalk:];
                                                     //                                                     break;
                                                 default:
                                                     break;
                                             }
                                             
                                         } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                             switch (platformType)
                                             {
                                                 case SSDKPlatformTypeWechat:
                                                     [appInfo SSDKSetupWeChatByAppId:wechatAppId
                                                                           appSecret:wechatAppkey];
                                                     break;
                                                 case SSDKPlatformTypeQQ:
                                                     [appInfo SSDKSetupQQByAppId:QQAppId
                                                                          appKey:QQAppKey
                                                                        authType:SSDKAuthTypeBoth];
                                                     break;
                                                     
                                                     
                                                     
                                                 default:
                                                     break;
                                             }
                                         }];
}

- (void)loadIFlySDK
{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths      = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", IFlyAppId];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
}

- (void)loadXGSDK:(NSDictionary *)launchOptions
{
    /**
     *  打开debug开关
     */
    [[XGSetting getInstance] enableDebug:YES];
    
    /**
     *  初始化推送sdk
     */
    [XGPush startApp:2200263532 appKey:@"I421M1FDFJ7U"];
    
    
    [XGPush isPushOn:^(BOOL isOn) {
        NSLog(@"[XGDemo] Push Is %@", isOn ? @"ON" : @"OFF");
    }];
    
    [self registerAPNS];
    
    PKPushRegistry *pushRegistry  = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate         = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    [XGPush handleLaunching:launchOptions successCallback:^{
        NSLog(@"[XGDemo] Handle launching success");
    } errorCallback:^{
        NSLog(@"[XGDemo] Handle launching error");
    }];
}



- (void)loadILiveSDK
{
    TIMManager *IMManger = [[ILiveSDK getInstance] getTIMManager];
    
    /**
     *  设置环境
     */
    NSNumber *evn = [[NSUserDefaults standardUserDefaults] objectForKey:kEnvParam];
    [IMManger setEnv:[evn intValue]];
    
    /**
     *  设置 APNS
     */
    TIMAPNSConfig *apnsConfig = [TIMAPNSConfig new];
    apnsConfig.openPush       = 1;
    [IMManger setAPNS:apnsConfig succ:nil fail:nil];
    
    /**
     *  设置日志回调的log等级
     */
    NSNumber *logLevel = [[NSUserDefaults standardUserDefaults] objectForKey:kLogLevel];
    [IMManger initLogSettings:YES logPath:[IMManger getLogPath]];
    [IMManger setLogLevel:(TIMLogLevel)[logLevel integerValue]];
    
    /**
     *  初始化sdk
     */
    [[ILiveSDK getInstance] initSdk:[ILiveAppId intValue] accountType:[ILiveAccountType intValue]];
    
    /**
     *  设置全局监听事件
     */
    M8GlobalListener *globalListener = [[M8GlobalListener alloc] init];
    
    [[ILiveSDK getInstance] setConnListener:globalListener];
    [[ILiveSDK getInstance] setUserStatusListener:globalListener];
    [IMManger setMessageListener:globalListener];
    
    
    
    //开启网络状态监听
    [globalListener startnetMonitoring];
    
}

#pragma mark -
/**
 *  程序挂起，来电、锁屏等情况
 *
 *  @param application application
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[TIMManager sharedInstance] doBackground:nil succ:nil fail:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[TIMManager sharedInstance] doForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"M8Tool"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error                  = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end


