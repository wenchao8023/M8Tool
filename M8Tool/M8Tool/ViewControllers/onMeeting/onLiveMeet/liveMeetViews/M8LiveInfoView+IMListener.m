//
//  M8LiveInfoView+IMListener.m
//  M8Tool
//
//  Created by chao on 2017/7/4.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8LiveInfoView+IMListener.h"

@implementation M8LiveInfoView (IMListener)


#pragma mark - 消息回调
- (void)onTextMessage:(ILVLiveTextMessage *)msg{
    [self addTextToView:[NSString stringWithFormat:@"收到文本消息:%@",msg.text]];
}

- (void)onCustomMessage:(ILVLiveCustomMessage *)msg{
    switch (msg.cmd) {
        case ILVLIVE_IMCMD_INTERACT_REJECT:
            [self addTextToView:[NSString stringWithFormat:@"%@拒绝了你的上麦邀请",msg.sendId]];
            break;
        case ILVLIVE_IMCMD_INVITE_CLOSE:
            [self addTextToView:[NSString stringWithFormat:@"%@已经下麦",msg.sendId]];
            break;
        case ILVLIVE_IMCMD_INTERACT_AGREE:
            [self addTextToView:[NSString stringWithFormat:@"%@同意了你的上麦邀请",msg.sendId]];
            break;
        case ILVLIVE_IMCMD_LEAVE:
            [self addTextToView:[NSString stringWithFormat:@"%@退出房间",msg.sendId]];
            break;
        case ILVLIVE_IMCMD_ENTER:
            [self addTextToView:[NSString stringWithFormat:@"%@进入房间",msg.sendId]];
            break;
        case ILVLIVE_IMCMD_CUSTOM_LOW_LIMIT:
        {
            //用户自定义消息
            NSString *text = [NSString stringWithFormat:@"收到自定义消息:cmd=%ld,data=%@",(long)msg.cmd,[[NSString alloc] initWithData:msg.data encoding:NSUTF8StringEncoding]];
            [self addTextToView:text];
            break;
        }
        default:
            break;
    }
}



@end
