//
//  MangerTeamViewController+UI.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController.h"

@interface MangerTeamViewController (UI)

- (void)onReloadDataInMainThread;

- (void)onDidSelectAtIndex:(NSIndexPath *_Nonnull)indexPath;

- (void)onHeaderViewAction:(UITapGestureRecognizer *_Nullable)tap;

- (void)onAddMemberAction;

- (void)onShareAction;

- (void)onAddAction;
@end
