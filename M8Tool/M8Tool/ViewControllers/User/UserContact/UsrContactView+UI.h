//
//  UsrContactView+UI.h
//  M8Tool
//
//  Created by chao on 2017/7/14.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "UsrContactView.h"

#import "FriendListViewController.h"

#import "MangerTeamViewController.h"

@interface UsrContactView (UI)

- (void)loadDataInMainThread;

- (void)onDidSelectAtIndex:(NSIndexPath *_Nonnull)indexPath;

- (void)onHeaderAction:(UITapGestureRecognizer *_Nullable)tap;

- (void)onMangerComAction:(UIButton *_Nullable)mangerBtn;

- (void)onCreateTeamAction;
@end
