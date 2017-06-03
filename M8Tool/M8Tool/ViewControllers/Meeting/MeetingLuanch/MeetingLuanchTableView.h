//
//  MeetingLuanchTableView.h
//  M8Tool
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface MeetingLuanchTableView : UITableView

/**
 *  隐藏的时候表示 发起直播会议
 */
@property (nonatomic, assign) BOOL isHiddenFooter;

@property (nonatomic, assign) NSInteger MaxMembers;



@end
