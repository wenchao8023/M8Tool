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
            
            NSLog(@"[TIMGroupManager] newMessage class : %@", [elem class]);
            
            
            // TIMTextElem 文本消息Elem
            if ([elem isKindOfClass:[TIMTextElem class]])
            {
                WCLog(@"收到 **%@** 第--%d--条消息<++%@++>", sender, i, ((TIMTextElem *)elem).text);
                
                NSString *text = ((TIMTextElem *)elem).text;
                
                [self addMember:[self.renderModelManger toNickWithUid:sender] withMsg:text];
            }
            
            
            // TIMGroupTipsElem 群Tips
            TIMConversation * conversation = [msg getConversation];
            
            if ([elem isKindOfClass:[TIMGroupTipsElem class]]) {
                TIMGroupTipsElem * tips_elem = (TIMGroupTipsElem * )elem;
                switch ([tips_elem type]) {
                    case TIM_GROUP_TIPS_TYPE_INVITE:
                        NSLog(@"invite %@ into group %@", [tips_elem userList], [conversation getReceiver]);
                        break;
                    case TIM_GROUP_TIPS_TYPE_QUIT_GRP:
                        NSLog(@"%@ quit group %@", [tips_elem userList], [conversation getReceiver]);
                        break;
                    default:
                        NSLog(@"ignore type");
                        break;
                }
            }
            
            
            // TIMGroupSystemElem 群系统消息
            if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
                TIMGroupSystemElem * system_elem = (TIMGroupSystemElem * )elem;
                switch ([system_elem type]) {
                    case TIM_GROUP_SYSTEM_ADD_GROUP_REQUEST_TYPE:
                        NSLog(@"user %@ request join group  %@", [system_elem user], [system_elem group]);
                        break;
                    case TIM_GROUP_SYSTEM_DELETE_GROUP_TYPE:
                        NSLog(@"group %@ deleted by %@", [system_elem group], [system_elem user]);
                        break;
                    case TIM_GROUP_SYSTEM_QUIT_GROUP_TYPE:
                        NSLog(@"user %@ quit group %@", [system_elem user], [system_elem group]);
                        break;
                    default:
                        NSLog(@"ignore type");
                        break;
                }
            }
        }
    }
}
@end
