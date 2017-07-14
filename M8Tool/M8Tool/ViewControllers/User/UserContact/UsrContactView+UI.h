//
//  UsrContactView+UI.h
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"

#import "FriendListViewController.h"

@interface UsrContactView (UI)

- (void)loadDataInMainThread;

- (void)onHeaderAction:(UITapGestureRecognizer *)tap;

- (void)onMangerComAction;


@end
