//
//  M8CallRenderView.h
//  M8Tool
//
//  Created by chao on 2017/6/9.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>




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


@property (nonatomic, assign) BOOL isFloatView;




@property (nonatomic, weak) id<CallRenderDelegate> _Nullable WCDelegate;

- (void)addTextToView:(id _Nullable)newText;

/**
 重新设置 视频流 位置
 */
- (void)updateRenderCollection;



@end
