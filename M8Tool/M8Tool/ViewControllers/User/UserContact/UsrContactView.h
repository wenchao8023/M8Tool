//
//  UsrContactView.h
//  M8Tool
//
//  Created by chao on 2017/5/25.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UsrContactDelegate <NSObject>

- (void)usrContactDidSelectContacts:(NSArray *_Nonnull)contacts;

@end


@interface UsrContactView : UITableView

@property (nonatomic, weak) id _Nullable WCDelegate;

@end
