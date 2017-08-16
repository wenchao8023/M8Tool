//
//  M8CallViewController+AsyncListener.h
//  M8Tool
//
//  Created by chao on 2017/7/21.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController.h"

/**
 异步监听房间中成员信息
 如果超过30s房间中成员只有自己，则提示用户是否退出房间
 如果提示30s，用户没有做其他操作，则自动为用户退出房间
 */
@interface M8CallViewController (AsyncListener)

/**
 开启异步监听
 */
- (void)onBeginAsyncListener;

@end
