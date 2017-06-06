//
//  M8ThemeCell.h
//  M8Tool
//
//  Created by chao on 2017/6/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M8ThemeModel.h"

@interface M8ThemeCell : UITableViewCell

- (void)config:(M8ThemeModel *)model isCurrentTheme:(BOOL)isCurrentTheme;

@end
