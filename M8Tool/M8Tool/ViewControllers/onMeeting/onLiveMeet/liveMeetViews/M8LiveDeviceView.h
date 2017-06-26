//
//  M8LiveDeviceView.h
//  M8Tool
//
//  Created by chao on 2017/6/23.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, M8LiveDeviceType) {
    M8LiveDeviceTypeHost,       ///>主播
    M8LiveDeviceTypeGust    ///>观众
};



@protocol LiveDeviceViewDelegate <NSObject>

- (void)LiveDeviceViewActionInfo:(NSDictionary *_Nonnull)actionInfo;

@end


@interface M8LiveDeviceView : UIView


@property (nonatomic, weak) id<LiveDeviceViewDelegate> _Nullable WCDelegate;

- (instancetype _Nonnull )initWithFrame:(CGRect)frame deviceType:(M8LiveDeviceType)deviceType;



@end
