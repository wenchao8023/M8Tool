//
//  UserTableViewCell.h
//  M8Tool
//
//  Created by chao on 2017/6/6.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTableViewModel.h"

@interface UserTableViewCell : UITableViewCell

- (void)config:(UserTableViewModel *)model;

@end
