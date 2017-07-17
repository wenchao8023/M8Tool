//
//  MangerTeamViewController+Net.h
//  M8Tool
//
//  Created by chao on 2017/7/17.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "MangerTeamViewController.h"

@interface MangerTeamViewController (Net)

- (void)onNetloadData;

- (void)onNetGetPartInfoWithDid:(NSString *_Nonnull)did;

@end
