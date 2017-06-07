//
//  M8LiveMeetViewController.h
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 直播会议发起界面
 */
@interface M8LiveMeetViewController : UIViewController

/**
 会议主题
 */
@property (nonatomic, copy, nullable) NSString *topic;
    
/**
 房间号
 */
@property (nonatomic, assign) NSInteger roomId;
    
/**
 主播
 */
@property (nonatomic, copy, nullable) NSString *host;

@end
