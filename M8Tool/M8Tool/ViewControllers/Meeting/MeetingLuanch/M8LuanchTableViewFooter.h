//
//  M8LuanchTableViewFooter.h
//  M8Tool
//
//  Created by chao on 2017/7/18.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TBFooterViewDelegate <NSObject>

- (void)TBFooterViewCurrentMembers:(NSArray *_Nullable)currentMembers;

@end



@interface M8LuanchTableViewFooter : UIView

@property (nonatomic, assign) NSInteger totalNumbers;

@property (nonatomic, weak) id<TBFooterViewDelegate> _Nullable WCDelegate;

@end
