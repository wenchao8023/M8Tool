//
//  M8CallComingListener.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallComingListener.h"

#import "M8RecvCallViewController.h"

@implementation M8CallComingListener

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation {

    M8RecvCallViewController *recvCallVC = [[M8RecvCallViewController alloc] init];
    recvCallVC.invitation = invitation;
    [[AppDelegate sharedAppDelegate] presentNavigationController:recvCallVC];
}

@end
