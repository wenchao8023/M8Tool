//
//  M8CallComingListener.m
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallComingListener.h"

#import "M8RecvVideoViewController.h"

#import "M8RecvAudioViewController.h"



@implementation M8CallComingListener

//-(void)onMultiCallInvitation:(TILCallInvitation *)invitation {

//    UIViewController *nav = [[AppDelegate sharedAppDelegate] topViewController];
//    NSLog(@"back form %@", NSStringFromClass([nav class]));
//    CSCallComingViewController *call = [[UIStoryboard storyboardWithName:@"CSCall" bundle:nil] instantiateViewControllerWithIdentifier:@"CSCallComingViewController"];
//    //    CallMultiRecvViewController *call = [[UIStoryboard storyboardWithName:@"CSCall" bundle:nil] instantiateViewControllerWithIdentifier:@"CallMultiRecvViewController"];
//    call.invite = invitation;
//    [nav presentViewController:call animated:YES completion:nil];
//}

- (void)onMultiCallInvitation:(TILCallInvitation *)invitation {
    
    if (invitation.callType == TILCALL_TYPE_VIDEO) {    // 视频来电
        M8RecvVideoViewController *recvVideoVC = [[M8RecvVideoViewController alloc] init];
        recvVideoVC.invitation = invitation;
        [[AppDelegate sharedAppDelegate] presentViewController:recvVideoVC];
    }
    else if (invitation.callType == TILCALL_TYPE_AUDIO) {
        M8RecvAudioViewController *recvVideoVC = [[M8RecvAudioViewController alloc] init];
        recvVideoVC.invitation = invitation;
        [[AppDelegate sharedAppDelegate] presentViewController:recvVideoVC];
    }
}




@end
