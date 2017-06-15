//
//  M8CallRenderView.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * _Nonnull kCallAction = @"kCallAction";
static NSString * _Nonnull kCallText   = @"kCallText";
static NSString * _Nonnull kCallValue  = @"kCallValue";


@protocol CallRenderDelegate <NSObject>

- (void)CallRenderActionInfo:(NSDictionary *_Nullable)actionInfo;

@end


@interface M8CallRenderView : UIView<TILCallMemberEventListener, TILCallNotificationListener, TILCallStatusListener>




/**
 会议发起人
 */
@property (nonatomic, copy, nonnull) NSString *hostIdentify;



/**
 获取 renderView
 */
@property (nonatomic, strong, nullable) TILMultiCall *call;


/**
 用于主叫方判断是取消通话还是结束通话
 */
@property (nonatomic, assign) BOOL shouldHangup;


@property (nonatomic, weak) id _Nullable WCDelegate;

- (void)addTextToView:(NSString *_Nullable)newText;

@end
