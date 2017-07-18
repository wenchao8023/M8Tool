//
//  M8MenuPushView.h
//  M8Tool
//
//  Created by chao on 2017/7/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuPushDelegate <NSObject>

- (void)MenuPushActionInfo:(NSDictionary *)info;

@end

@interface M8MenuPushView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame itemCount:(int)itemCount meetType:(M8MeetType)meetType;

@property (nonatomic, weak) id<MenuPushDelegate> _Nullable WCDelegate;

@end
