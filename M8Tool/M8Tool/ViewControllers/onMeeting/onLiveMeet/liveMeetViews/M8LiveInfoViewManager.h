//
//  M8LiveInfoViewManager.h
//  M8Tool
//
//  Created by chao on 2017/6/28.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@protocol M8LiveInfoViewManagerDelegate <NSObject>

- (void)LiveInfoViewManagerLog:(id)log;

@end



@interface M8LiveInfoViewManager : NSObject

@property (nonatomic, weak) id<M8LiveInfoViewManagerDelegate> _Nullable WCDelegate;

@end
