//
//  M8CallVideoRenderView.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * _Nonnull kCallAction = @"kCallAction";
static NSString * _Nonnull kCallText   = @"kCallText";


@protocol CallVideoRenderDelegate <NSObject>

- (void)CallVideoRenderActionInfo:(NSDictionary *_Nullable)actionInfo;

@end


@interface M8CallVideoRenderView : UIView<TILCallMemberEventListener, TILCallNotificationListener>


/**
 会议发起人
 */
@property (nonatomic, copy, nullable) NSString *host;


/**
 获取 renderView
 */
@property (nonatomic, strong, nullable) TILMultiCall *call;


- (void)addTextToView:(NSString *_Nullable)newText;

@property (nonatomic, weak) id _Nullable WCDelegate;

@end
