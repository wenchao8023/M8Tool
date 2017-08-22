//
//  AppDelegate+XGPushConfig.h
//  M8Tool
//
//  Created by chao on 2017/7/21.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "AppDelegate.h"


#import "XGSetting.h"

@interface AppDelegate (XGPushConfig)

- (void)registerAPNS;

- (void)sendLocalNotify:(NSString *_Nullable)alertBody;

@end
