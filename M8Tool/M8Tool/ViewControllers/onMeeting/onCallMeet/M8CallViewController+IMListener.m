//
//  M8CallViewController+IMListener.m
//  M8Tool
//
//  Created by chao on 2017/7/13.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8CallViewController+IMListener.h"

@implementation M8CallViewController (IMListener)

/**
 新消息通知
 
 @param messages 新消息（TIMMessage*）列表
 */
- (void)onNewMessages:(NSArray*)messages
{
    for (TIMMessage *msg in messages)
    {
        NSString *sender = msg.sender;
//        BOOL isSelf = msg.isSelf;
//        NSDate *curDate = msg.timestamp;
//        NSString *timeStr = [CommonUtil getDateStrWithTime:[curDate timeIntervalSince1970]];
        
        for (int i = 0; i < msg.elemCount; i++)
        {
            TIMElem *elem = [msg getElem:i];
            
            if ([elem isKindOfClass:[TIMTextElem class]])
            {
                WCLog(@"收到 **%@** 第--%d--条消息<++%@++>", sender, i, ((TIMTextElem *)elem).text);
                
                NSString *text = ((TIMTextElem *)elem).text;
                
                [self addMember:[self.renderModelManger toNickWithUid:sender] withMsg:text];
//                [self addMember:sender withMsg:text];
            }
        }
    }
}
@end
